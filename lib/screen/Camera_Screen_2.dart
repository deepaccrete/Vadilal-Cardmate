
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/ImageUploadApi.dart';
import '../componets/button.dart';
import 'bottomnav.dart';

/// This function should be placed in the same file as your Bottom Navigation Bar.
/// Your "Scan" button should call this method.
// Future<void> _openScannerAndShowPreview(BuildContext context) async {
//   // This function is now self-contained and handles the entire scan-to-preview flow.
//
//   // 1. Start the document scan
//   final List<String>? imagePaths = await _startScanForPreview();
//   if (imagePaths == null || imagePaths.isEmpty) {
//     // User cancelled the scan or an error occurred.
//     return;
//   }
//
//   // 2. If scan is successful, navigate to the preview screen.
//   // The 'as BuildContext' is important if you are in a context that may be null.
//   if (context.mounted) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CameraScreen2(imagePaths: imagePaths),
//       ),
//     );
//   }
// }

/// This is the helper scan function, now separate from the screen's state.
// Future<List<String>?> _startScanForPreview() async {
//   try {
//     final scanner = FlutterDocScanner();
//     final dynamic result = await scanner.getScannedDocumentAsImages();
//
//     print("[Preview Scan] Raw scan result: $result");
//
//     if (result is Map && result.containsKey('Uri')) {
//       final dynamic uriValue = result['Uri'];
//       final List<String> paths = [];
//       final regex = RegExp(r'imageUri=(file:///[^}]+)');
//
//       if (uriValue is List && uriValue.isNotEmpty) {
//         for (var page in uriValue) {
//           final rawPageString = page.toString();
//           final match = regex.firstMatch(rawPageString);
//           if (match != null) paths.add(match.group(1)!.replaceFirst('file://', ''));
//         }
//       } else if (uriValue is String) {
//         final matches = regex.allMatches(uriValue);
//         for (final match in matches) {
//           paths.add(match.group(1)!.replaceFirst('file://', ''));
//         }
//       }
//
//       if (paths.isNotEmpty) return paths;
//     }
//   } catch (e, s) {
//     print("[Preview Scan] ❗ Exception during scan: $e\n$s");
//   }
//   return null;
// }


class CameraScreen2 extends StatefulWidget {
  // It now accepts the scanned image paths as a parameter.
  final List<String> imagePaths;
  const CameraScreen2({super.key, required this.imagePaths});

  @override
  State<CameraScreen2> createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  String? _frontImagePath;
  String? _backImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _assignImagePaths();
  }

  /// Assigns the passed image paths to the state variables.
  void _assignImagePaths() {
    if (widget.imagePaths.isNotEmpty) {
      _frontImagePath = widget.imagePaths[0];
    }
    if (widget.imagePaths.length > 1) {
      _backImagePath = widget.imagePaths[1];
    }
  }


  /// A helper method to show a loading indicator.
  void _setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }

  /// The Save button's logic remains mostly the same.
  Future<void> _saveAndUploadImages() async {
    if (_frontImagePath == null) {
      _showError("No image to save.");
      return;
    }
    _setLoading(true);

    try {
      bool uploaded = false;
      // Handle two-sided case
      if (_backImagePath != null) {
        uploaded = await ImageuploadApi.uploadImage(
          frontImage: File(_frontImagePath!),
          backImage: File(_backImagePath!),
        );
        _showSnackBarAndNavigate(uploaded, isTwoSided: true);

      } else { // Handle single-sided case
        uploaded = await ImageuploadApi.uploadImage(frontImage: File(_frontImagePath!));
        _showSnackBarAndNavigate(uploaded, isTwoSided: false);
      }
    } catch (e) {
      print("Error during upload/save: $e");
      _showError("An error occurred while saving.");
    } finally {
      if(mounted){
        _setLoading(false);
      }
    }
  }

  void _showSnackBarAndNavigate(bool uploaded, {required bool isTwoSided}) {
    final message = uploaded
        ? (isTwoSided ? 'Both images uploaded successfully' : 'Image uploaded successfully')
        : (isTwoSided ? 'Failed to upload images. Please try again.' : 'Failed to upload image. Please try again.');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: uploaded ? Colors.green : Colors.red,
      ),
    );

    // On success, navigate back to the root screen (e.g., your home screen)
    if(mounted && uploaded){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Bottomnav()),
            (route) => false,
      );
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bool canSave = _frontImagePath != null && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Document"),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display scanned images or a placeholder.
                        _buildImageDisplay(),
                      ],
                    ),
                  ),
                ),
                // --- MODIFIED: Buttons are at the bottom now ---
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        child: Text("Retake"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonButton(
                        onTap: (){
                          if(canSave){
                            _saveAndUploadImages();
                          }else{
                            null;
                          }},
                          // canSave ? _saveAndUploadImages : null;},
                        bgcolor: canSave ? Theme.of(context).primaryColor : Colors.grey,
                        bordercircular: 10,
                        height: height * 0.065,
                        child: Text('Save', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Show a loading overlay.
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text("Saving...", style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          )
      ),
    );
  }

  Widget _buildImageDisplay() {
    if (_frontImagePath == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No document to preview.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        _ImageCard(title: "Front Side", imagePath: _frontImagePath!),
        if (_backImagePath != null) ...[
          const SizedBox(height: 20),
          _ImageCard(title: "Back Side", imagePath: _backImagePath!),
        ]
      ],
    );
  }
}

/// A custom widget to display an image in a styled card.
class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.title,
    required this.imagePath,
  });
  final String title;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<bool>(
            future: imageFile.exists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == true) {
                return Image.file(
                  imageFile,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height* 0.25,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return AspectRatio(
                      aspectRatio: 16/9,
                      child: Center(child: Text("Error loading image: $error")),
                    );
                  },
                );
              }
              return const AspectRatio(
                aspectRatio: 16/9,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent),
                        SizedBox(height: 8),
                        Text("Image file not found.", textAlign: TextAlign.center),
                      ],
                    )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}





/*

import 'dart:io';

import 'package:camera_app/api/ImageUploadApi.dart';
import 'package:camera_app/componets/button.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen2 extends StatefulWidget {
  const CameraScreen2({super.key});

  @override
  State<CameraScreen2> createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  // Using nullable strings for the image paths is correct.
  String? _frontImagePath;
  String? _backImagePath;
  bool _isLoading = false;

  /// A helper method to show a loading indicator.
  void _setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }

  /// Initiates the document scan and processes the result.
  ///
  /// The [label] is used for logging purposes to distinguish between scan calls.
  /// Returns the file path of the scanned image, or null on failure.
  Future<List<String>?> _startScan(String label) async {
    try {
      final scanner = FlutterDocScanner();
      final dynamic result = await scanner.getScannedDocumentAsImages();

      print("[$label] Raw scan result: $result");
      if (result != null) {
        print("[$label] Type of result: ${result.runtimeType}");
      }

      if (result is Map && result.containsKey('Uri')) {
        final dynamic uriValue = result['Uri'];
        print("[$label] Type of 'Uri' value from plugin: ${uriValue.runtimeType}");

        final List<String> paths = [];
        final regex = RegExp(r'imageUri=(file:///[^}]+)');

        // --- FIX: Handle both List and String for the 'Uri' value ---
        if (uriValue is List && uriValue.isNotEmpty) {
          // Case 1: The value is a List (expected for multi-page)
          for (var page in uriValue) {
            final rawPageString = page.toString();
            final match = regex.firstMatch(rawPageString);

            if (match != null && match.groupCount > 0) {
              final uri = match.group(1)!;
              final path = uri.replaceFirst('file://', '');
              paths.add(path);
            }
          }
        } else if (uriValue is String) {
          // Case 2: The value is a single String containing one or more pages.
          // Use allMatches to find every occurrence of the image path pattern.
          final matches = regex.allMatches(uriValue);
          for (final match in matches) {
            if (match.groupCount > 0) {
              final uri = match.group(1)!;
              final path = uri.replaceFirst('file://', '');
              paths.add(path);
            }
          }
        }

        if (paths.isNotEmpty) {
          print("[$label] ✅ Extracted ${paths.length} image path(s).");
          return paths;
        } else {
          print("[$label] ❌ Could not extract any paths from the result.");
          _showError("Scanner returned no valid images.");
          return null;
        }

      } else {
        print("[$label] ❌ Check failed. Result is not a Map or does not contain 'Uri' key.");
        _showError("Received an unexpected result format from the scanner.");
      }
    } catch (e, s) {
      print("[$label] ❗ Exception during scan: $e\n$s");
      _showError("An error occurred: $e");
    }
    return null;
  }

  // /// Scans a single-sided document.
  // Future<void> scanSingleSide() async {
  //   if (_isLoading) return;
  //   _setLoading(true);
  //
  //   final imagePath = await _startScan('Single Side');
  //   if (mounted) { // Check if the widget is still in the tree.
  //     setState(() {
  //       _frontImagePath = imagePath;
  //       _backImagePath = null; // Clear the back image if any.
  //     });
  //   }
  //
  //   _setLoading(false);
  // }
  //
  // /// Scans a double-sided document in two steps.
  // Future<void> scanDoubleSide() async {
  //   if (_isLoading) return;
  //   _setLoading(true);
  //
  //   // --- Step 1: Scan Front Side ---
  //   final frontPath = await _startScan('Front Side');
  //   if (frontPath == null) {
  //     _showError("Failed to capture the front image.");
  //     _setLoading(false);
  //     return;
  //   }
  //
  //   // Update state immediately to show the front image.
  //   if(mounted) {
  //     setState(() {
  //       _frontImagePath = frontPath;
  //       _backImagePath = null;
  //     });
  //   }
  //
  //
  //   // --- Step 2: Prompt user and scan Back Side ---
  //   final continueScan = await _showConfirmationDialog(
  //     "Front side captured successfully. Proceed to scan the back side?",
  //   );
  //
  //   if (continueScan != true) {
  //     _setLoading(false);
  //     return;
  //   }
  //
  //   // ❗ Note on Future.delayed:
  //   // This delay can be a workaround for native library race conditions.
  //   // It's best to confirm if the plugin offers a callback or a more reliable
  //   // method to know when it's safe to start the next scan.
  //   await Future.delayed(const Duration(milliseconds: 300));
  //
  //   final backPath = await _startScan('Back Side');
  //   if (backPath == null) {
  //     _showError("Failed to capture the back image.");
  //     _setLoading(false);
  //     return;
  //   }
  //
  //   if (mounted) {
  //     setState(() {
  //       _backImagePath = backPath;
  //     });
  //   }
  //
  //   _setLoading(false);
  // }

  // --- NEW: A single method to start the scan flow ---
  Future<void> startDocumentScan() async {
    if (_isLoading) return;
    _setLoading(true);

    final imagePaths = await _startScan('Document Scan');
    if (mounted) {
      if (imagePaths == null || imagePaths.isEmpty) {
        // No images were returned, or the user cancelled.
        setState(() {
          _frontImagePath = null;
          _backImagePath = null;
        });
      } else if (imagePaths.length == 1) {
        // Single image scanned
        setState(() {
          _frontImagePath = imagePaths[0];
          _backImagePath = null;
        });
      } else {
        // Multiple images scanned, we'll take the first two.
        setState(() {
          _frontImagePath = imagePaths[0];
          _backImagePath = imagePaths[1];
        });
      }
    }

    _setLoading(false);
  }

  /// Shows a confirmation dialog before proceeding to the next step.
  Future<bool?> _showConfirmationDialog(String msg) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice.
      builder: (_) => AlertDialog(
        title: const Text("Next Step"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  /// Shows an error message using a SnackBar.
  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<void> uploadtoApi() async {
    if (_frontImagePath == null) {
      _showError("No image to save.");
      return;
    }
    _setLoading(true);

    try {
      bool uploaded = false;
      // Handle two-sided case
      if (_backImagePath != null) {
        uploaded = await ImageuploadApi.uploadImage(
          frontImage: File(_frontImagePath!),
          backImage: File(_backImagePath!),
        );
        _showsnakbarandMsg(uploaded, isTwoside: true);

      } else { // Handle single-sided case
        uploaded = await ImageuploadApi.uploadImage(frontImage: File(_frontImagePath!));
        _showsnakbarandMsg(uploaded, isTwoside: false);
      }
    } catch (e) {
      print("Error during upload/save: $e");
      _showError("An error occurred while saving.");
    } finally {
      if(mounted){
        _setLoading(false);
      }
    }
  }
  void _showsnakbarandMsg(bool uploded, {required bool isTwoside}){

    final message = uploded
        ? (isTwoside? 'Both images uploaded successfully' : 'Image uploaded successfully')
        :(isTwoside ?'Failed to upload images. Please try again.' : 'Failed to upload image. Please try again.');
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(message),
  backgroundColor: uploded? Colors.green :Colors.red
  )
);

if(mounted && uploded){

  setState(() {
    _frontImagePath = null;
    _backImagePath = null;
  });
}

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    final bool canSave = _frontImagePath != null && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Scanner"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display scanned images or a placeholder.
                        _buildImageDisplay(),
                        const SizedBox(height: 20),
                        CommonButton(
                          onTap:() {
                            if(canSave){
                              uploadtoApi();
                            }else{
                              null;
                            }

                          },
                          bgcolor: canSave ? Theme.of(context).primaryColor : Colors.grey, // Visual feedback for disabled state
                          bordercircular: 10,
                          height: height * 0.07,
                          child: Text('Save', style: GoogleFonts.poppins(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // --- MODIFIED: The UI is now much simpler ---
                ElevatedButton.icon(
                  icon: const Icon(Icons.document_scanner_outlined),
                  onPressed: _isLoading ? null : startDocumentScan,
                  label: const Text("Scan Document"),
                ),
              ],
            ),
          ),
          // Show a loading overlay.
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  /// A widget to build the loading indicator overlay.
  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text("Scanning...", style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          )
      ),
    );
  }

  /// A widget that builds the area for displaying scanned images.
  Widget _buildImageDisplay() {
    if (_frontImagePath == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No document scanned yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        _ImageCard(title: "Front Side", imagePath: _frontImagePath!),
        if (_backImagePath != null) ...[
          const SizedBox(height: 20),
          _ImageCard(title: "Back Side", imagePath: _backImagePath!),
        ]
      ],
    );
  }
}
  /// A widget that builds the action buttons for scanning.
//   Widget _buildScanButtons() {
//     return Container(
//
//       color: Colors.transparent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ElevatedButton.icon(
//             icon: const Icon(Icons.document_scanner_outlined),
//             onPressed: _isLoading ? null : scanSingleSide,
//             label: const Text("Scan Single Side"),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.flip_to_front_outlined),
//             onPressed: _isLoading ? null : scanDoubleSide,
//             label: const Text("Scan Front & Back"),
//           ),
//         ],
//       ),
//     );
//   }
// }

/// A custom widget to display an image in a styled card.
class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Ensures the image respects the border radius.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // Use a FutureBuilder to handle potential errors when loading the file.
          FutureBuilder<bool>(
            future: imageFile.exists(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Image.file(
                  imageFile,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height* 0.25,
                  fit: BoxFit.fitWidth,
                  // Add an error builder for the image itself.
                  errorBuilder: (context, error, stackTrace) {
                    return const AspectRatio(
                      aspectRatio: 16/9,
                      child: Center(child: Text("Error loading image")),
                    );
                  },
                );
              }
              // Show a placeholder or error if the file doesn't exist.
              return const AspectRatio(
                aspectRatio: 16/9,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent),
                        SizedBox(height: 8),
                        Text("Image file not found.", textAlign: TextAlign.center),
                      ],
                    )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
*/



// OLD CAMERA CODE FOR SCANNER SINGLE AND DOUBLE WITH BUTTOM

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
  Future<String?> _startScan(String label) async {
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

        String? rawPageString;

        // --- FIX for type exception ---
        // The logs show the plugin sometimes returns a String instead of a List.
        // This code now handles both possibilities.
        if (uriValue is List) {
          if (uriValue.isEmpty) {
            print("[$label] ❌ Scanned result URI list is empty.");
            _showError("Scanner returned no images.");
            return null;
          }
          rawPageString = uriValue.first.toString();
        } else if (uriValue is String) {
          // If the plugin returns a single string, use it directly.
          rawPageString = uriValue;
        } else {
          print("[$label] ❌ 'Uri' key has an unexpected type: ${uriValue.runtimeType}");
          _showError("Received an unexpected data format from the scanner.");
          return null;
        }

        final regex = RegExp(r'imageUri=(file:///[^}]+)');
        final match = regex.firstMatch(rawPageString);

        if (match != null && match.groupCount > 0) {
          final uri = match.group(1)!;
          final path = uri.replaceFirst('file://', '');
          print("[$label] ✅ Extracted image path: $path");
          return path;
        } else {
          print("[$label] ❌ Regex did not match any imageUri in '$rawPageString'.");
          _showError("Could not parse the scanned image path.");
        }
      } else {
        print("[$label] ❌ Check failed. Result is not a Map or does not contain 'Uri' key.");
        _showError("Received an unexpected result format from the scanner.");
      }
    } catch (e, s) {
      // Catching exceptions is crucial for plugin interactions.
      print("[$label] ❗ Exception during scan: $e\n$s");
      // Displaying the actual error in the SnackBar is more helpful for debugging.
      _showError("An error occurred: $e");
    }
    return null;
  }


  /// Scans a single-sided document.
  Future<void> scanSingleSide() async {
    if (_isLoading) return;
    _setLoading(true);

    final imagePath = await _startScan('Single Side');
    if (mounted) { // Check if the widget is still in the tree.
      setState(() {
        _frontImagePath = imagePath;
        _backImagePath = null; // Clear the back image if any.
      });
    }

    _setLoading(false);
  }

  /// Scans a double-sided document in two steps.
  Future<void> scanDoubleSide() async {
    if (_isLoading) return;
    _setLoading(true);

    // --- Step 1: Scan Front Side ---
    final frontPath = await _startScan('Front Side');
    if (frontPath == null) {
      _showError("Failed to capture the front image.");
      _setLoading(false);
      return;
    }

    // Update state immediately to show the front image.
    if(mounted) {
      setState(() {
        _frontImagePath = frontPath;
        _backImagePath = null;
      });
    }


    // --- Step 2: Prompt user and scan Back Side ---
    final continueScan = await _showConfirmationDialog(
      "Front side captured successfully. Proceed to scan the back side?",
    );

    if (continueScan != true) {
      _setLoading(false);
      return;
    }

    // ❗ Note on Future.delayed:
    // This delay can be a workaround for native library race conditions.
    // It's best to confirm if the plugin offers a callback or a more reliable
    // method to know when it's safe to start the next scan.
    await Future.delayed(const Duration(milliseconds: 300));

    final backPath = await _startScan('Back Side');
    if (backPath == null) {
      _showError("Failed to capture the back image.");
      _setLoading(false);
      return;
    }

    if (mounted) {
      setState(() {
        _backImagePath = backPath;
      });
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

  Future<void>uploadtoApi()async{
    if(_frontImagePath == null){
      _showError('No Image for Save');
    }

    try{
      bool uploded = false ;
      if(_backImagePath != null){
        final uploaded = await ImageuploadApi.uploadImage(
          frontImage:File(_frontImagePath!),
          backImage: File(_backImagePath!),
        );
        uploded = true;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Bottomnav()));
        _showsnakbarandMsg(uploded, isTwoside: true);

      }else{
        final uploaded = await ImageuploadApi.uploadImage(
            frontImage: File(_frontImagePath!));
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Bottomnav()));
      }
    }catch(e){
      print('Error While Uploading ${e}');
    }finally{
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Scanner"),
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

                        CommonButton(

                          bordercircular: 10,
                          height: height * 0.07,
                          onTap: (){
                            uploadtoApi();
                          },
                          child: Text('Save', style: GoogleFonts.poppins(color: Colors.white),),)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons are moved here for better UI layout.
                _buildScanButtons(),
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

  /// A widget that builds the action buttons for scanning.
  Widget _buildScanButtons() {
    return Container(

      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.document_scanner_outlined),
            onPressed: _isLoading ? null : scanSingleSide,
            label: const Text("Scan Single Side"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.flip_to_front_outlined),
            onPressed: _isLoading ? null : scanDoubleSide,
            label: const Text("Scan Front & Back"),
          ),
        ],
      ),
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

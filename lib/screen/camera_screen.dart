import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/db/hive_pimage.dart';
import 'package:camera_app/model/dbModel/imagemodel.dart';
import 'package:camera_app/screen/dualimage.dart';
import 'package:camera_app/screen/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../api/ImageUploadApi.dart';
import '../widget/cameraoverlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'bottomnav.dart';

// Future<String> _recognizationInIsolate(String jpegpath) async {
//   final input = InputImage.fromFilePath(jpegpath);
//   final rec = TextRecognizer();
//   final result = await rec.processImage(input);
//   await rec.close();
//   return result.text;
// }

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final textRecognizer = TextRecognizer();
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isInitialized = false;

  String captureMode = "single";
  String? frontImagePath;
  String? backImagePath;
  bool capturingBack = false;
  bool isCapturing = false;
bool istwoside = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
    startSyncListener();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
        cameras![0],
        ResolutionPreset.veryHigh,

    );
    await controller!.initialize();
    if (!mounted) return;
    setState(() => isInitialized = true);
  }

  /*  Future<void> pickImageFromGallery(BuildContext context)async{
    try{
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          if(pickedFile == null) return;

          final String path = pickedFile.path;

          setState(() {
            isProcessing = true;
          });

          final inputImage = InputImage.fromFilePath(path);
          final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

          setState(() {
            isProcessing = false;
          });

          final String fullText = recognizedText.text;


          if(captureMode == 'single') {
            final ok = await Navigator.push<bool>(context,
              MaterialPageRoute(builder: (_) =>
                  ImagePreview(imagePath: path,
                      initialText: fullText),
              ),
            ) ?? false;

            if (ok) Navigator.pop(context, {'front': path});
          }else{
            if(frontImagePath == null){
              frontImagePath = path
            }
          }

          }



    }
    catch(e){

    }
  }*/

  Future<File?> cropImage(File imageFile, BuildContext context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3), // 👈 custom ratio
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primarycolor,
          toolbarWidgetColor: Colors.white,
          // Only show default presets if needed
          // aspectRatioPresets: [CropAspectRatioPreset.original],
          lockAspectRatio: false, // Set to true if you want to force 2:3
        ),
        WebUiSettings(context: context),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

// @override
// (int, int)? get data => (2,3);
//
//   @override
// String get name => '2 x 3 (customized)';

  // Future<void> pickImageFromGallery(BuildContext context) async {
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //     );
  //     if (pickedFile == null) return;
  //
  //
  //     final originalFile = File(pickedFile.path);
  //
  //     /// crop image
  //     final croppedFile = await cropImage(originalFile, context);
  //     if(croppedFile==null) {
  //       isProcessing = false;
  //       setState(() {
  //       });
  //       return;
  //     };
  //
  //     final String path = croppedFile.path;
  //
  //     setState(() {
  //
  //       isProcessing = true;
  //     });
  //
  //
  //
  //
  //     // final String path = pickedFile.path;
  //
  //     setState(() {
  //       isProcessing = true;
  //     });
  //
  //     final inputImage = InputImage.fromFilePath(path);
  //     final RecognizedText recognizedText = await textRecognizer.processImage(
  //       inputImage,
  //     );
  //
  //     setState(() {
  //       isProcessing = false;
  //     });
  //
  //     final String fulltext = recognizedText.text;
  //
  //
  //     if (captureMode == 'single') {
  //
  //
  //
  //       // Upload image after text recognition
  //       final uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
  //       if (!uploaded) {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(SnackBar(content: Text('Failed to upload image.')));
  //       }
  //
  //       final ok =
  //           await Navigator.push<bool>(
  //             context,
  //             MaterialPageRoute(
  //               builder:
  //                   (_) => ImagePreview(imagePath: path, initialText: fulltext),
  //             ),
  //           ) ??
  //           false;
  //
  //       if (ok) Navigator.pop(context, {'front': path});
  //     } else {
  //       if (frontImagePath == null) {
  //         frontImagePath = path;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Front image selected. Now select back image.'),
  //           ),
  //         );
  //       } else {
  //         backImagePath = path;
  //
  //         // upload both images only when both are ready
  //         final uploaded = await ImageuploadApi.uploadImage(frontImage: File(frontImagePath!),
  //         backImage: File(backImagePath!)
  //         );
  //
  //         if(!uploaded){
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Faild to upload images'))
  //           );
  //           frontImagePath = backImagePath = null;
  //           return;
  //         }
  //
  //         final ok =
  //             await Navigator.push<bool>(
  //               context,
  //               MaterialPageRoute(
  //                 builder:
  //                     (_) => Dualimage(
  //                       frontImage: frontImagePath!,
  //                       backImage: backImagePath!,
  //                     ),
  //               ),
  //             ) ??
  //             false;
  //
  //         if (ok) {
  //           Navigator.pop(context, {
  //             'front': frontImagePath!,
  //             'back': backImagePath!,
  //           });
  //         } else {
  //           frontImagePath = backImagePath = null;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error selecting image: $e');
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to pick image.')));
  //   }
  // }

/*

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;


      final originalFile = File(pickedFile.path);

      /// crop image
      final croppedFile = await cropImage(originalFile, context);
      if(croppedFile==null) {
        isProcessing = false;
        setState(() {
        });
        return;
      };

      final String path = croppedFile.path;

      setState(() {

        isProcessing = true;
      });




      // final String path = pickedFile.path;

      // setState(() {
      //   isProcessing = true;
      // });
      //
      // final inputImage = InputImage.fromFilePath(path);
      // final RecognizedText recognizedText = await textRecognizer.processImage(
      //   inputImage,
      // );
      //
      // setState(() {
      //   isProcessing = false;
      // });
      //
      // final String fulltext = recognizedText.text;


      if (captureMode == 'single') {
        bool uploaded =  false;

if(await hasInternet()){
  uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
  if(!uploaded){
    await HivePimage.savePendingImage(
      PendingImage(id: Uuid().v4(),
          frontImage: path)
    );
  }
}else{
  await HivePimage.savePendingImage(
    PendingImage(id: Uuid().v4(),
        frontImage:path)
  );
}



        // Upload image after text recognition
        // final uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
        if (!uploaded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Image Saved for later upload')));
        }

        // final ok =
        //     await Navigator.push<bool>(
        //       context,
        //       MaterialPageRoute(
        //         builder:
        //             (_) => ImagePreview(imagePath: path, initialText: fulltext),
        //       ),
        //     ) ??
        //     false;
        //
        // if (ok) Navigator.pop(context, {'front': path});
      } else {
        if (frontImagePath == null) {
          frontImagePath = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Front image selected. Now select back image.'),
            ),
          );
        } else {
          backImagePath = path;


          bool uploaded = false;
          // upload both images only when both are ready
          // final uploaded = await ImageuploadApi.uploadImage(frontImage: File(frontImagePath!),
          //
          //
          //
          //     backImage: File(backImagePath!)
          // );

          if(await hasInternet()){
            uploaded = await ImageuploadApi.uploadImage(frontImage: File(frontImagePath!),
            backImage: File(backImagePath!)
            );
          }

          if(!uploaded){
            await HivePimage.savePendingImage(
              PendingImage(id: Uuid().v4(),
                  frontImage: frontImagePath!,
              backPath: backImagePath!
              ),
            );
          }else{
            await HivePimage.savePendingImage(
              PendingImage(id: Uuid().v4(),
                  frontImage: frontImagePath!,
                  backPath: backImagePath!
              ),
            );
          }
          if(!uploaded){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Images saved for upload later.'))
            );
            frontImagePath = backImagePath = null;
            return;
          }

          final ok =
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => Dualimage(
                        frontImage: frontImagePath!,
                        backImage: backImagePath!,
                      ),
                ),
              ) ??
              false;

          if (ok) {
            Navigator.pop(context, {
              'front': frontImagePath!,
              'back': backImagePath!,
            });
          } else {
            frontImagePath = backImagePath = null;
          }
        }
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image.')));
    }
  }
*/

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      final originalFile = File(pickedFile.path);

      // Crop image
      final croppedFile = await cropImage(originalFile, context);
      if (croppedFile == null) {
        setState(() => isProcessing = false);
        return;
      }

      final String path = croppedFile.path;

      setState(() => isProcessing = true);

      if (captureMode == 'single') {
        bool uploaded = false;

        if (await hasInternet()) {
          uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
        }

        if (!uploaded) {
          await HivePimage.savePendingImage(
            PendingImage(id: Uuid().v4(), frontImage: path),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved for later upload')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully')),
          );
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Bottomnav()),
              (route) => false,
        );
      } else {
        // Double side
        if (frontImagePath == null) {
          frontImagePath = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Front image selected. Now select back image.')),
          );
        } else {
          backImagePath = path;

          bool uploaded = false;
          if (await hasInternet()) {
            uploaded = await ImageuploadApi.uploadImage(
              frontImage: File(frontImagePath!),
              backImage: File(backImagePath!),
            );
          }

          if (!uploaded) {
            await HivePimage.savePendingImage(
              PendingImage(
                id: Uuid().v4(),
                frontImage: frontImagePath!,
                backPath: backImagePath!,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Images saved for later upload')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Images uploaded successfully')),
            );
          }

          // Reset and navigate
          frontImagePath = null;
          backImagePath = null;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Bottomnav()),
                (route) => false,
          );
        }
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image.')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Future<void> takePicture(BuildContext context) async {
  //   if (!controller!.value.isInitialized || isCapturing) return;
  //   isCapturing = true;
  //
  //   try {
  //     final Directory dir = await getTemporaryDirectory();
  //     final String originalPath = join(
  //       dir.path,
  //       '${DateTime.now().millisecondsSinceEpoch}.jpg',
  //     );
  //
  //     final XFile file = await controller!.takePicture();
  //     await file.saveTo(originalPath);
  //
  //     setState(() {
  //       isProcessing = true;
  //     });
  //
  //     // crop image
  //
  //     final croppedFile = await cropImage(File(originalPath), context);
  //     if (croppedFile == null ){
  //      setState(() {
  //        isCapturing = false;
  //        isProcessing= false;
  //      });
  //       return;
  //     }
  //
  //
  //     final String path = croppedFile.path;
  //
  //
  //     // OCR
  //     final inputImage = InputImage.fromFilePath(path);
  //     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  //
  //     setState(() {
  //       isProcessing = false;
  //     });
  //
  //     final String fulltext = recognizedText.text;
  //     print('OCR found: $fulltext');
  //
  //     if (captureMode == 'single') {
  //       // ✅ Upload single image
  //       // final uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
  //
  //       // no internet func//
  //       if(await hasInternet()){
  //          uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
  //
  //       if(!uploaded){
  //         await HivePimage.savePendingImage(
  //           PendingImage(id: Uuid().v4(),
  //               frontImage: path,),
  //         );
  //       }
  //       }else{
  //         await HivePimage.savePendingImage(
  //           PendingImage(id: Uuid().v4(),
  //               frontImage: path)
  //         );
  //       }
  //
  //
  //
  //
  //
  //
  //       if (uploaded) {
  //         final ok = await Navigator.push<bool>(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => ImagePreview(imagePath: path, initialText: fulltext),
  //           ),
  //         ) ?? false;
  //
  //         if (ok) Navigator.pop(context, {'front': path});
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed')));
  //       }
  //     } else {
  //       // two-side mode
  //       if (frontImagePath == null) {
  //         frontImagePath = path;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Front Captured. Now capture Back')),
  //         );
  //       } else {
  //         backImagePath = path;
  //
  //         // ✅ Upload both images when back is captured
  //         // final uploaded = await ImageuploadApi.uploadImage(
  //         //   frontImage: File(frontImagePath!),
  //         //   backImage: File(backImagePath!),
  //         // );
  //         if (await hasInternet()) {
  //           final uploaded = await ImageuploadApi.uploadImage(
  //             frontImage: File(frontImagePath!),
  //             backImage: File(backImagePath!),
  //           );
  //           if (!uploaded) {
  //             await HiveBoxes.savePendingImage(
  //               PendingImage(
  //                 id: Uuid().v4(),
  //                 frontPath: frontImagePath!,
  //                 backPath: backImagePath!,
  //               ),
  //             );
  //           }
  //         } else {
  //           await HiveBoxes.savePendingImage(
  //             PendingImage(
  //               id: Uuid().v4(),
  //               frontPath: frontImagePath!,
  //               backPath: backImagePath!,
  //             ),
  //           );
  //         }
  //
  //         if (uploaded) {
  //           final ok = await Navigator.push<bool>(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => Dualimage(
  //                 frontImage: frontImagePath!,
  //                 backImage: backImagePath!,
  //               ),
  //             ),
  //           ) ?? false;
  //
  //           if (ok) {
  //             Navigator.pop(context, {
  //               'front': frontImagePath!,
  //               'back': backImagePath!,
  //             });
  //           } else {
  //             frontImagePath = backImagePath = null;
  //           }
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed')));
  //           frontImagePath = backImagePath = null;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error taking picture: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   } finally {
  //     isCapturing = false;
  //     setState(() {});
  //   }
  // }


  Future<void> takePicture(BuildContext context) async {
    if (!controller!.value.isInitialized || isCapturing) return;
    isCapturing = true;

    try {
      final Directory dir = await getTemporaryDirectory();
      final String originalPath = join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile file = await controller!.takePicture();
      await file.saveTo(originalPath);

      // setState(() {
      //   isProcessing = true;
      // });

      // Crop image
      final croppedFile = await cropImage(File(originalPath), context);
      if (croppedFile == null) {
        setState(() {
          isCapturing = false;
          // isProcessing = false;
        });
        return;
      }

      final String path = croppedFile.path;

      // OCR
      // final inputImage = InputImage.fromFilePath(path);
      // final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      //
      // setState(() {
      //   isProcessing = false;
      // });
      //
      // final String fulltext = recognizedText.text;
      // print('OCR found: $fulltext');


      //=====>single side-----------//

      if (captureMode == 'single') {
        bool uploaded = false;

        if (await hasInternet()) {
          uploaded = await ImageuploadApi.uploadImage(frontImage: File(path));
          if (!uploaded) {
            await HivePimage.savePendingImage(
              PendingImage(id: Uuid().v4(), frontImage: path),
            );
          }
        } else {
          await HivePimage.savePendingImage(
            PendingImage(id: Uuid().v4(), frontImage: path),
          );
        }

        // if (uploaded) {
        //   final ok = await Navigator.push<bool>(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => ImagePreview(imagePath: path, initialText: fulltext),
        //     ),
        //   ) ?? false;
        //
        //   if (ok) Navigator.pop(context, {'front': path});
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved for later upload')));
        // }

        // Navigate home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Bottomnav()),
              (route) => false,
        );

        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(uploaded ? 'Image uploaded successfully' : 'Image saved for later upload'),
          ),
        );
      }




      else {

        // Two-side mode
        if (frontImagePath == null) {
          frontImagePath = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Front Captured. Now capture Back')),
          );
          istwoside = true;
        } else {
          backImagePath = path;

          bool uploaded = false;

          if (await hasInternet()) {
            uploaded = await ImageuploadApi.uploadImage(
              frontImage: File(frontImagePath!),
              backImage: File(backImagePath!),
            );
            if (!uploaded) {
              await HivePimage.savePendingImage(
                PendingImage(
                  id: Uuid().v4(),
                  frontImage: frontImagePath!,
                  backPath: backImagePath!,
                ),
              );
            }
          } else {
            await HivePimage.savePendingImage(
              PendingImage(
                id: Uuid().v4(),
                frontImage: frontImagePath!,
                backPath: backImagePath!,
              ),
            );
          }

          // if (uploaded) {
          //   final ok = await Navigator.push<bool>(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) => Dualimage(
          //         frontImage: frontImagePath!,
          //         backImage: backImagePath!,
          //       ),
          //     ),
          //   ) ?? false;
          //   istwoside = false;
          //   if (ok) {
          //     Navigator.pop(context, {
          //       'front': frontImagePath!,
          //       'back': backImagePath!,
          //     });
          //     istwoside = false;
          //   } else {
          //     frontImagePath = backImagePath = null;
          //   }
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Images saved for later upload')));
          //   frontImagePath = backImagePath = null;
          //   istwoside = false;
          // }
// Navigate home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Bottomnav()),
                (route) => false,
          );

          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                uploaded
                    ? 'Both images uploaded successfully'
                    : 'Images saved for later upload',
              ),
            ),
          );
          // Reset paths
          frontImagePath = null;
          backImagePath = null;
          istwoside = false;
        }
      }
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      isCapturing = false;
      setState(() {});
    }
  }

  Future<bool> hasInternet()async{
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }


  void startSyncListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncPendingImages();
      }
    });
  }

  Future<void> syncPendingImages() async {
    final images = await HivePimage.getAllPendingImages();

    for (final image in images) {
      bool success = false;
      try {
        if (image.backPath == null) {
          success = await ImageuploadApi.uploadImage(frontImage: File(image.frontImage));
        } else {
          success = await ImageuploadApi.uploadImage(
            frontImage: File(image.frontImage),
            backImage: File(image.backPath!),
          );
        }

        if (success) {
          await HivePimage.deletePendingImage(image.id);
        }
      } catch (e) {
        print('Error syncing image ${image.id}: $e');
      }
    }
  }




  // Future<bool>
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    textRecognizer.close();
  }



  Widget modeButton(String label) {
    final lower = label.toLowerCase();
    final selected = captureMode == lower;
    // bool isSelected = captureMode == label.toLowerCase();
    return GestureDetector(
      onTap:
          () => setState(() {
            captureMode = lower;
            capturingBack = false;
            frontImagePath = null;
            backImagePath = null;
          }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: OverflowBox(
              alignment: Alignment.center,
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller!.value.previewSize!.height,
                  height: controller!.value.previewSize!.width,
                  child: CameraPreview(controller!),
                ),
              ),
            ),
          ),


          CameraOverlay(),
          // SizedBox(height: 40,),
          Positioned(
            bottom: 30 ,
            left: 0,
            right: 0,
            // color: Colors.red,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    istwoside == false?
                    modeButton("Single"):
                    SizedBox(),
                    modeButton("Two-side")],
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // image from gallary
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10,right: 0,left: 5),
                        child: GestureDetector(
                          onTap: () {
                            pickImageFromGallery(context);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(Icons.image, color: Colors.lightBlue),
                                Text(
                                  'Image',
                                  style: GoogleFonts.inter(
                                    color: Colors.lightBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // click picture
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              takePicture(context);
                            },
                            child:
                                isProcessing
                                    ? Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircularProgressIndicator(
                                        color: Colors.red,
                                      ),
                                    )
                                    : Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 50,
                        width: 50,
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}
class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
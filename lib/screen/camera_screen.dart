import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/dualimage.dart';
import 'package:camera_app/screen/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../api/ImageUploadApi.dart';
import '../widget/cameraoverlay.dart';
import 'package:image_picker/image_picker.dart';

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

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
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
  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final String path = pickedFile.path;

      setState(() {
        isProcessing = true;
      });

      final inputImage = InputImage.fromFilePath(path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        isProcessing = false;
      });

      final String fulltext = recognizedText.text;
      // Upload image after text recognition
      final uploaded = await ImageuploadApi.uploadImage(File(path));
      if (!uploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
      }


      if (captureMode == 'single') {
        final ok = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => ImagePreview(imagePath: path, initialText: fulltext),
          ),
        ) ?? false;

        if (ok) Navigator.pop(context, {'front': path});
      } else {
        if (frontImagePath == null) {
          frontImagePath = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Front image selected. Now select back image.')),
          );
        } else {
          backImagePath = path;
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => Dualimage(frontImage: frontImagePath!, backImage: backImagePath!),
            ),
          ) ?? false;

          if (ok) {
            Navigator.pop(context, {'front': frontImagePath!, 'back': backImagePath!});
          } else {
            frontImagePath = backImagePath = null;
          }
        }
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image.')),
      );
    }
  }


  Future<void> takePicture(BuildContext context) async {
    if (!controller!.value.isInitialized || isCapturing) return;
    isCapturing = true;

    try {
      final Directory dir = await getTemporaryDirectory();
      final String path = join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      print(path);
      // Take picture and save it to the path
      final XFile file = await controller!.takePicture();
      await file.saveTo(path);

      setState(() {
        isProcessing = true;
      });

      // image text extract
      final inputImage = InputImage.fromFilePath(path);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      setState(() {
        isProcessing = false;
      });
      final String fulltext = recognizedText.text;
      print('ocr found: $fulltext');




      // final String fulltext = await compute(_recognizationInIsolate, path);
      // print('ocr found: $fulltext');

      if (captureMode == 'single') {
        final ok =
            await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ImagePreview(imagePath: path, initialText: fulltext),
              ),
            ) ??
            false;
        if (ok) Navigator.pop(context, {'front': path});
      } else {
        if (frontImagePath == null) {
          frontImagePath = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Front Captured NOw capture Back')),
          );
        } else {
          backImagePath = path;
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

      //
      //
      // // Navigate to the preview screen
      // final bool confirmedPath = await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => ImagePreview(imagePath: path)),
      // )?? false;
      //
      // if (!confirmedPath) {
      //   // User chose to retake the picture
      //   isCapturing = false;
      //   return;
      // }
      //
      // // If capturing mode is "single", return only the front image
      // if (captureMode == "single") {
      //   Navigator.pop(context, {'front': path});
      // } else {
      //   // If capturing mode is "two-side", capture both front and back images
      //   if (!capturingBack) {
      //     setState(() {
      //       frontImagePath = path;
      //       capturingBack = true;
      //     });
      //
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Front is Captured. NOw Shoot back Side')));
      //
      //     isCapturing = false;
      //     return ;
      //     // await Future.delayed(Duration(milliseconds: 200));
      //     // await takePicture(context);
      //   } else {
      //     backImagePath = path;
      //     await Future.delayed(Duration(milliseconds: 200));
      //     Navigator.pop(context, {
      //       'front': frontImagePath!,
      //       'back': backImagePath!,
      //     });
      //
      //   //   reset flag for next time
      //     setState(() {
      //       capturingBack = false;
      //     });
      //   }
      // }
    } catch (e) {
      print('Error taking picture: $e');
    } finally {
      isCapturing = false;
      setState(() {});
    }
  }

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
          CameraPreview(controller!),
          CameraOverlay(),
          // SizedBox(height: 40,),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
              // color: Colors.red,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [modeButton("Single"), modeButton("Two-side")],
                  ),
                  const SizedBox(height: 16),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            pickImageFromGallery(context);
                          },
                          child: Container(
                            child:Column(
                              children: [
                                Icon(Icons.image,color:  Colors.lightBlue,),
                                Text('Image',style: GoogleFonts.inter(
                                  color:  Colors.lightBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600
                                ),)
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            takePicture(context);
                          },
                          child:isProcessing ? Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.circle
                            ),
                            child: CircularProgressIndicator(color: Colors.red,),):
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),


                        Container(
                          child:Column(
                            children: [
                              Icon(Icons.rotate_right,color:  Colors.lightBlue),
                              Text('Rotate',style: GoogleFonts.inter(
                                  color: Colors.lightBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600
                              ),)
                            ],
                          ),
                        ),

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

import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:camera_app/api/CardApi.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
// import 'package:camera_app/screen/add.dart';
import 'package:camera_app/screen/details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:universal_html/html.dart' as web;
// web
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final String? token;

  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  // border
  final outborder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.transparent),
    borderRadius: BorderRadius.circular(10),
  );

  // Map<String, dynamic> dataCardToExportableMap(DataCard card) {
  //   return {
  //     'Card ID': card.cardID?.toString() ?? '',
  //     'Company Name': card.companyName ?? '',
  //     'Person Names': card.personDetails?.map((p) => p.name).join(', ') ?? '',
  //     'Person Designations': card.personDetails?.map((p) => p.position).join(', ') ?? '',
  //     'Person Phone ': card.personDetails?.map((p) => p.phoneNumber).join(',') ?? '',
  //     'Company Phone': card.companyPhoneNumber ?? '',
  //     'Company Address': card.companyAddress?.join(', ') ?? '',
  //     'Company Email': card.companyEmail ?? '',
  //     'Web Address': card.webAddress ?? '',
  //     'Work Details': card.companySWorkDetails ?? '',
  //     'GSTIN': card.gSTIN ?? '',
  //     'Created By': card.createdBy?.toString() ?? '',
  //     'Created At': card.createdAt ?? '',
  //   };
  // }
  //
  // // List<CardDetails> _cards = [];

  List<DataCard> _cardapi = [];
  List<DataCard> get _reversedCardApi => List.from(_cardapi.reversed);

  bool isCardLoading = true;
  String? errormessage;

  Uint8List? decodeBase64Image(String base64String) {
    try {
      print('Attempting to decode base64 string...');

      if (base64String.isEmpty) {
        print('Error: base64 string is empty');
        return null;
      }

      // Print the first part of the string to see what format we're dealing with
      print('Original string starts with: ${base64String.substring(0, min(50, base64String.length))}');

      String cleanBase64 = base64String;

      // If the string starts with 'data:', extract the base64 part
      if (cleanBase64.startsWith('data:')) {
        int commaIndex = cleanBase64.indexOf(',');
        if (commaIndex != -1) {
          cleanBase64 = cleanBase64.substring(commaIndex + 1);
          print('Removed data: prefix directly from string');
        }
      }

      // Remove any whitespace
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'[\s\n]'), '');
      // Add padding if needed
      int paddingLength = cleanBase64.length % 4;
      if (paddingLength > 0) {
        cleanBase64 += '=' * (4 - paddingLength);
      }

      try {
        // First decode attempt
        var bytes = base64Decode(cleanBase64);
        print('First decode successful, got ${bytes.length} bytes');

        // Check if the result is another base64 string
        String decodedString = String.fromCharCodes(bytes);
        if (decodedString.contains('base64,')) {
          print('Found another base64 string, decoding again...');
          String secondBase64 = decodedString.split('base64,').last;
          // Clean up the second base64 string
          secondBase64 = secondBase64.replaceAll(RegExp(r'[\s\n]'), '');
          paddingLength = secondBase64.length % 4;
          if (paddingLength > 0) {
            secondBase64 += '=' * (4 - paddingLength);
          }
          bytes = base64Decode(secondBase64);
          print('Second decode successful, got ${bytes.length} bytes');
        }

        // Verify this is actually an image by checking for common image headers
        if (bytes.length > 8) {
          // Check for JPEG header (FF D8)
          if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
            print('Detected JPEG image format');
            return bytes;
          }
          // Check for PNG header (89 50 4E 47)
          if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
            print('Detected PNG image format');
            return bytes;
          }
          // Check for GIF header (47 49 46)
          if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
            print('Detected GIF image format');
            return bytes;
          }

          print(
            'Warning: No valid image header detected. First 8 bytes: [${bytes.take(8).map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}]',
          );
        }

        return bytes;
      } catch (e) {
        print('Base64 decoding error: $e');
        return null;
      }
    } catch (e) {
      print('Error in decodeBase64Image: $e');
      return null;
    }
  }

  Future<void> FetchCard() async {
    setState(() {
      isCardLoading = true;
      errormessage = null;
    });
    try {
      CardModel cardModel = await CardApi.getCard();
      if (cardModel.success == 1 && cardModel.data != null) {
        setState(() {
          _cardapi = cardModel.data!;
          isCardLoading = false;
        });
      }else if(cardModel.success == 0){
        isCardLoading = false;
        _cardapi = [];
        setState(() {

        });
      }
    } catch (e) {
      setState(() {
        errormessage = "Something Went Wrong ==========>>>>>>>>>>>> $e";
      });
    }
  }

  // Future<void> exportDataToExcel(BuildContext context, List<Map<String, dynamic>> data) async {
  //   try {
  //     if (data.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
  //       return;
  //     }
  //
  //     final fileName = "exported_data.xlsx";
  //
  //     // --- Excel Generation (NOW ON MAIN THREAD - as compute failed persistently) ---
  //     // This part will run on the UI thread and may cause frame drops for large datasets.
  //     var excel = Excel.createExcel();
  //     Sheet sheet = excel['Sheet1'];
  //
  //     List<String> headers = data[0].keys.toList();
  //     sheet.appendRow(headers);
  //
  //     for (var row in data) {
  //       sheet.appendRow(headers.map((key) => row[key].toString()).toList());
  //     }
  //
  //     final List<int>? excelBytesList = excel.encode();
  //     if (excelBytesList == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to encode Excel data.')));
  //       return;
  //     }
  //     final Uint8List excelBytes = Uint8List.fromList(excelBytesList);
  //
  //     // --- Web Platform Handling ---
  //     if (kIsWeb) {
  //       final blob = web.Blob([excelBytes], 'application/vnd.ms-excel');
  //       final url = web.Url.createObjectUrlFromBlob(blob);
  //       final anchor =
  //           web.AnchorElement(href: url)
  //             ..download = fileName
  //             ..click();
  //       web.Url.revokeObjectUrl(url);
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel file downloaded for web.')));
  //       return;
  //     }
  //
  //     // --- Mobile Platforms Handling (Android & iOS) ---
  //
  //     // Save the bytes to a temporary file
  //     final tempDir = await getTemporaryDirectory();
  //     final tempFilePath = '${tempDir.path}/$fileName';
  //     final tempFile = io.File(tempFilePath);
  //     await tempFile.writeAsBytes(excelBytes);
  //     print('Excel bytes temporarily saved to: ${tempFile.path}');
  //
  //     // Now, use share_plus to let the user save or share the file
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel file generated. Opening share dialog...')));
  //
  //     // Pass the temporary file path to share_plus
  //     await Share.shareXFiles([XFile(tempFile.path)], text: 'Here is your exported data!');
  //
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel file shared successfully!')));
  //
  //     // Clean up the temporary file after sharing (it's copied by the OS)
  //     if (await tempFile.exists()) {
  //       await tempFile.delete();
  //       print('Temporary Excel file deleted: ${tempFile.path}');
  //     }
  //   } catch (e) {
  //     print('Export failed: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadCard();
    FetchCard();
  }

  /*Future<void> _loadCard() async {
    final box = await Hive.openBox<CardDetails>('cardbox');
    setState(() {
      _cards = box.values.toList();
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    List<DataCard> fillterCard = [];
    if (searchController.text.toString().isEmpty) {
      fillterCard = _reversedCardApi;
    } else {
      fillterCard =
          _reversedCardApi.where(
            (_element) {
              final companyName = _element.companyName?.toLowerCase() ?? '';
              return companyName.contains(searchController.text.toLowerCase());
            },
            // => (_element.companyName!.toLowerCase().contains(searchController.text.toLowerCase()))
          ).toList();
    }

    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    // List<Map<String, dynamic>> exportableData = _cardapi.map((card) => card).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: screenBGColor,
        body: RefreshIndicator(
          color: primarycolor,
          backgroundColor: Colors.grey.shade300,
          onRefresh: () {
            return FetchCard();
          },
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.red,
              // height: height,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  // name
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                        child: Text(
                          '${appStore.userData?.firstname![0]}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${appStore.userData?.firstname} ${appStore.userData?.lastname}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(),
                  Card(
                    elevation: 10,
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: TextFormField(
                        onChanged: (v) {
                          setState(() {});
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Name, email, tags,etc...',
                          hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.blue,  // Removing blue background
                    width: width,
                    height: height * 0.75, // Adjusted height to leave space for FAB
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Expanded(
                          child:
                              isCardLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : _cardapi.isEmpty?Container(
                                child: Image.asset('assets/images/no card found .png'),
                              ):AnimationLimiter(
                                    child: ListView.builder(
                                      // itemCount: _cardapi.length,
                                      itemCount: fillterCard.length,
                                      itemBuilder: (context, index) {
                                        // final card = _cardapi[index];
                                        final card = fillterCard[index];

                                        final frontImageBytes =
                                            card.isBase64 == 1 &&
                                                    card.cardFrontImageBase64 != null &&
                                                    card.cardFrontImageBase64!.isNotEmpty
                                                ? decodeBase64Image(card.cardFrontImageBase64!)
                                                : null;

                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(seconds: 2),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Card(
                                                  elevation: 10,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => DetailsScreen(dataCard: card),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(16),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: height * 0.1,
                                                                width: width * 0.2,
                                                                decoration: BoxDecoration(
                                                                  color: darkcolor,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child:
                                                                    card.isBase64 == 1
                                                                        ? (frontImageBytes != null
                                                                            ? ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              child: Image.memory(
                                                                                frontImageBytes,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            )
                                                                            : Icon(
                                                                              Icons.image,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            ))
                                                                        : ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          child: Image.network(
                                                                            card.cardFrontImageBase64 ?? '',
                                                                            fit: BoxFit.cover,
                                                                            errorBuilder:
                                                                                (context, error, stackTrace) =>
                                                                                    Icon(Icons.image, size: 40),
                                                                          ),
                                                                        ),
                                                              ),
                                                              SizedBox(width: 20),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      card.companyName?.toString() ?? 'No data',
                                                                      style: GoogleFonts.raleway(
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 14,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      card.companyAddress!.join(',') ?? "No Data",
                                                                      style: GoogleFonts.raleway(
                                                                        fontWeight: FontWeight.w400,
                                                                        fontSize: 11,
                                                                        color: subtext,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.date_range, color: Colors.grey),
                                                                  Text(
                                                                    card.createdAt!.substring(0, 10),
                                                                    style: GoogleFonts.inter(
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12,
                                                                      color: Colors.grey.shade700,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(5),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.blue,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Text(
                                                                      'General',
                                                                      style: GoogleFonts.poppins(
                                                                        color: Colors.white,
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Icon(Icons.more_vert_outlined),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildImage(DataCard dataCard) {
    final imagestr = dataCard.cardFrontImageBase64 ?? '';
    final isBase64 = dataCard.isBase64 ?? 0;

    if (isBase64 == 1) {
      final byte = decodeBase64Image(imagestr);
      if (byte != null) {
        return Image.memory(byte, fit: BoxFit.cover);
      } else {
        return Icon(Icons.image);
      }
    }

    return Image.network(imagestr, fit: BoxFit.cover);
  }

  Widget _buildShimmerCarde(BuildContext context) {
    // Get screen dimensions. Replace 'height' and 'width' variables if they are global
    // If you are using height and width from MediaQuery, then this is good.
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: height * 0.1,
                    width: width * 0.2,
                    decoration: BoxDecoration(color: darkcolor, borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Icon(Icons.image, color: Colors.white, size: 40),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: GoogleFonts.raleway(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                        ),
                        Text('', style: GoogleFonts.raleway(fontWeight: FontWeight.w400, fontSize: 11, color: subtext)),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.grey),
                      Text(
                        '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'General',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(Icons.more_vert_outlined),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// list
/*  Container(
                  width: width,
                  height: height *0.2,
                  child:ListView.builder(
                      itemCount: widget.datalist!.length,
                      itemBuilder: (context, index){

                    final data  = widget.datalist![index];
                    return   Container(
                           color: Colors.white,
                           width: width,
                           height: height * 0.6,
                           child: Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Card(
                                   elevation: 10,
                                   child: InkWell(
                                     onTap: () {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) => DetailsScreen(),
                                         ),
                                       );
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: screenBGColor,


                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                       padding: EdgeInsets.all(5),
                                       child: Column(
                                         children: [
                                           Row(
                                             mainAxisAlignment:
                                                 MainAxisAlignment.spaceAround,
                                             children: [
                                               Container(
                                                 height: height * 0.1,
                                                 width: width * 0.2,
                                                 decoration: BoxDecoration(
                                                   shape: BoxShape.circle,
                                                   color: darkcolor,
                                                 ),
                                                 child: Icon(
                                                   Icons.image,
                                                   color: Colors.white,
                                                   size: 40,
                                                 ),
                                               ),
                                               SizedBox(width: 20),
                                               Expanded(
                                                 child: Container(
                                                   width: width * 0.5,
                                                   // color: Colors.purple,
                                                   child: Column(
                                                     mainAxisAlignment:
                                                         MainAxisAlignment.start,
                                                     crossAxisAlignment:
                                                         CrossAxisAlignment.start,
                                                     children: [
                                                       Text(
                                                         data['name'].toString(),
                                                         textScaler: TextScaler.linear(
                                                           1.2,
                                                         ),

                                                         style: GoogleFonts.raleway(
                                                           fontWeight: FontWeight.w700,
                                                           fontSize: 16,
                                                           color: Colors.black,
                                                         ),
                                                       ),
                                                       Text(
                                                         data['note'].toString(),
                                                         textScaler: TextScaler.linear(
                                                           1.2,
                                                         ),
                                                         style: GoogleFonts.raleway(
                                                           fontWeight: FontWeight.w400,
                                                           fontSize: 11,
                                                           color: subtext,
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           ),
                                           Divider(),
                                           Row(
                                             mainAxisAlignment:
                                                 MainAxisAlignment.spaceBetween,
                                             children: [
                                               Padding(
                                                 padding: const EdgeInsets.only(
                                                   left: 15,
                                                   top: 15,
                                                   bottom: 15,
                                                 ),
                                                 child: Row(
                                                   children: [
                                                     Icon(
                                                       Icons.date_range,
                                                       color: Colors.grey,
                                                     ),
                                                     Text(
                                                       DateTime.now().day.toString(),
                                                       style: GoogleFonts.inter(
                                                         fontWeight: FontWeight.w700,
                                                         fontSize: 12,
                                                         color: Colors.grey.shade700,
                                                       ),
                                                     ),
                                                     SizedBox(width: 2),
                                                     Text(
                                                       DateTime.now().month.toString(),
                                                       style: GoogleFonts.inter(
                                                         fontWeight: FontWeight.w700,
                                                         fontSize: 12,
                                                         color: Colors.grey.shade700,

                                                       ),
                                                     ),
                                                     SizedBox(width: 2),

                                                     Text(
                                                       DateTime.now().year.toString(),
                                                       style: GoogleFonts.inter(
                                                         fontWeight: FontWeight.w700,
                                                         fontSize: 12,
                                                         color: Colors.grey.shade700,

                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),

                                               Row(
                                                 children: [
                                                   Container(
                                                     padding: EdgeInsets.all(5),
                                                     decoration: BoxDecoration(
                                                       color: Colors.blue,
                                                       borderRadius:
                                                           BorderRadius.circular(10),
                                                     ),
                                                     child: Text(
                                                       'General',
                                                       style: GoogleFonts.poppins(
                                                         color: Colors.white,
                                                         fontSize: 10,
                                                         fontWeight: FontWeight.w600
                                                       ),
                                                     ),
                                                   ),
                                                   Icon(Icons.more_vert_outlined),
                                                 ],
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ),

                               SizedBox(height: 10),
                             ],
                           ),
                         );

                      }),
                )*/

///hive data
/* Expanded(
//                         child: _cards.isEmpty
//                             ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.person_search, size: 100, color: Colors.grey.shade300),
//                               Text(
//                                 'No Card Found',
//                                 style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         )
//                             : ListView.builder(
//                           itemCount: _cards.length,
//                           itemBuilder: (context, index) {
//                             final card = _cards[index];
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Card(
//                                 elevation: 10,
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => DetailsScreen(
//                                             cardDetails: card,
//                                           index: index
//                                         ),
//                                       ),
//                                     ).then((result){
//                                       if(result == true){
//                                         _loadCard();
//                                       }
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(16),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Container(
//                                               height: height * 0.1,
//                                               width: width * 0.2,
//                                               decoration: BoxDecoration(
//                                                 color: darkcolor,
//                                               ),
//                                               child: Icon(Icons.image, color: Colors.white, size: 40),
//                                             ),
//                                             SizedBox(width: 20),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     card.fullname!,
//                                                     style: GoogleFonts.raleway(
//                                                       fontWeight: FontWeight.w700,
//                                                       fontSize: 16,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     card.address!,
//                                                     style: GoogleFonts.raleway(
//                                                       fontWeight: FontWeight.w400,
//                                                       fontSize: 11,
//                                                       color: subtext,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Divider(),
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.date_range,
//                                                   color: Colors.grey,
//                                                 ),
//                                                 Text(
//                                                '23 May 2025',
//                                                   style: GoogleFonts.inter(
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 12,
//                                                     color: Colors.grey.shade700,
//                                                   ),
//                                                 ),
//
//                                               ],
//                                             ),
//
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   padding: EdgeInsets.all(5),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.blue,
//                                                     borderRadius:
//                                                     BorderRadius.circular(10),
//                                                   ),
//                                                   child: Text(
//                                                     'General',
//                                                     style: GoogleFonts.poppins(
//                                                         color: Colors.white,
//                                                         fontSize: 10,
//                                                         fontWeight: FontWeight.w600
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Icon(Icons.more_vert_outlined),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       )*/

////////////////////////////////////
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Card(
//     elevation: 10,
//     child: InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailsScreen(),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           // color: Colors.red,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   height: height * 0.1,
//                   width: width * 0.2,
//                   decoration: BoxDecoration(
//                     // shape: BoxShape.circle,
//                     color: darkcolor,
//                   ),
//                   child: Icon(
//                     Icons.image,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Container(
//                       // height: height * 0.08,
//                       width: width * 0.5,
//                       // color: Colors.purple,
//                       child: Column(
//                         mainAxisAlignment:
//                             MainAxisAlignment.start,
//                         crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'XYZ Person',
//                             textScaler: TextScaler.linear(
//                               1.2,
//                             ),
//
//                             style: GoogleFonts.raleway(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             'Location of dummy, address of dummy, location map, directions to dummy',
//                             textScaler: TextScaler.linear(
//                               1.2,
//                             ),
//                             style: GoogleFonts.raleway(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 11,
//                               color: subtext,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Divider(),
//             Container(
//               // color: Colors.blueGrey,
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.date_range,
//                         color: Colors.grey,
//                         size: 25,
//                       ),
//                       Text(
//                         "23 May 25",
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   Row(
//                     children: [
//                       Container(
//                         // margin: EdgeInsets.all(5),
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius:
//                               BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           'General',
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Icon(Icons.more_vert_outlined),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),`

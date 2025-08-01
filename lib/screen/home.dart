import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:camera_app/api/CardApi.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/screen/details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// web
import 'package:shimmer/shimmer.dart';

import '../util/const.dart';
import 'login1.dart';

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



  List<DataCard> _cardapi = [];

  List<DataCard> get _reversedCardApi => List.from(_cardapi.reversed);

  bool isCardLoading = true;
  String? errormessage;


  // image decode for base 64
/*  Uint8List? decodeBase64Image(String base64String) {
    try {
      print('Attempting to decode base64 string...');

      if (base64String.isEmpty) {
        print('Error: base64 string is empty');
        return null;
      }

      // Print the first part of the string to see what format we're dealing with
      print(
        'Original string starts with: ${base64String.substring(0, min(50, base64String.length))}',
      );

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
          if (bytes[0] == 0x89 &&
              bytes[1] == 0x50 &&
              bytes[2] == 0x4E &&
              bytes[3] == 0x47) {
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
  }*/

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
      } else if (cardModel.success == 0) {
        isCardLoading = false;
        _cardapi = [];
        if(cardModel.msg=='jwt expired'){
          logout(context);
        }
        setState(() {});
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

bool ispersonvisible = true;

  @override
  Widget build(BuildContext context) {
    List<DataCard> fillterCard = [];

    if (searchController.text.toString().isEmpty) {
      fillterCard = _reversedCardApi;
    } else {
      final searchTextLower = searchController.text.toLowerCase(); // Optimize by getting lowercase text once

      fillterCard = _reversedCardApi.where(
            (_element) {
          // 1. Check if any person's name matches
          bool personNameMatches = false;
          if (_element.personDetails != null && _element.personDetails!.isNotEmpty) {
            personNameMatches = _element.personDetails!.any((person) {
              final personName = person.name?.toLowerCase() ?? ''; // Handle null person name
              return personName.contains(searchTextLower);
            });
          }

          // 2. Check if the company name matches
          final companyName = _element.companyName?.toLowerCase() ?? ''; // Handle null company name
          final companyNameMatches = companyName.contains(searchTextLower);

          // 3. Return true if EITHER personNameMatches OR companyNameMatches
          return personNameMatches || companyNameMatches;
        },
      ).toList();
    }
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    // List<Map<String, dynamic>> exportableData = _cardapi.map((card) => card).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: screenBGColor,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            color:  primarycolor,
            backgroundColor: Colors.grey.shade300,
            onRefresh: () {
              return FetchCard();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  //  NAME
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Text(
                          '${appStore.userData?.firstname![0]}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${appStore.userData?.firstname} ${appStore.userData?.lastname}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  // SEARCH BAR
                  Card(
                    elevation: 10,
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        onChanged: (v) {
                          setState(() {});
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Name, email, tags,etc...',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
                  Expanded(
                    child: Container(
                      // color: Colors.blue,  // Removing blue background
                      // width: width,
                      // Adjusted height to leave space for FAB
                      child: Column(
                        children: [
                    
                          Expanded(
                            child:
                            isCardLoading
                                ? ListView.builder(
                                itemBuilder: (context, index)=> Shimmer.fromColors(
                                    child: _buildShimmerCarde(context),
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade300))
                            // Center(child: CircularProgressIndicator())
                                : _cardapi.isEmpty
                                ? Container(
                              child: Image.asset(
                                'assets/images/no card found .png',
                              ),
                            )
                                : AnimationLimiter(
                              child: ListView.builder(
                                // itemCount: _cardapi.length,
                                itemCount: fillterCard.length,
                                itemBuilder: (context, index) {
                                  // final card = _cardapi[index];
                                  final card = fillterCard[index];
                    
                                  // final frontImageBytes =
                                  //     card.isBase64 == 1 &&
                                  //             card.cardFrontImageBase64 !=
                                  //                 null &&
                                  //             card
                                  //                 .cardFrontImageBase64!
                                  //                 .isNotEmpty
                                  //         ? decodeBase64Image(
                                  //           card.cardFrontImageBase64!,
                                  //         )
                                  //         : null;
                    
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(seconds: 2),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            8.0,
                                          ),
                                          child: Card(
                                            elevation: 10,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        DetailsScreen(
                                                          dataCard:
                                                          card,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  children: [
                    
                                                    Row(
                                                      children: [
                                                        // Image
                                                        Container(
                                                          height:
                                                          height *
                                                              0.1,
                                                          width:
                                                          width * 0.2,
                                                          decoration: BoxDecoration(
                                                            color:
                                                            darkcolor,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                          ),
                                                          child:
                                                          // card.isBase64 ==
                                                          //         1
                                                          //     ? (frontImageBytes !=
                                                          //             null
                                                          //         ? ClipRRect(
                                                          //           borderRadius: BorderRadius.circular(
                                                          //             8,
                                                          //           ),
                                                          //           child: Image.memory(
                                                          //             frontImageBytes,
                                                          //             fit:
                                                          //                 BoxFit.cover,
                                                          //           ),
                                                          //         )
                                                          //         : Icon(
                                                          //           Icons.image,
                                                          //           color:
                                                          //               Colors.white,
                                                          //           size:
                                                          //               40,
                                                          //         )):
                                                          ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                            child: Image.network(
                                                              card.cardFrontImageBase64 ??
                                                                  '',
                                                              fit:
                                                              BoxFit.cover,
                                                              errorBuilder:
                                                                  (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                  ) => Icon(
                                                                Icons.image,
                                                                size:
                                                                40,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20,),
                    
                                                        // person Name And Company Name
                                                        Expanded(
                                                          child: Builder(
                                                            builder: (context) {
                                                              final validPersons = card.personDetails!
                                                                  .where((person) =>
                                                              person.name != null &&
                                                                  person.name!.trim().isNotEmpty &&
                                                                  person.name!.toLowerCase() != 'null')
                                                                  .toList();
                    
                                                              final showCompanyName = (card.companyName ?? '').trim().isNotEmpty;
                    
                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Show valid person(s)
                                                                  ...validPersons.map((person) {
                                                                    final hasPosition = person.position != null &&
                                                                        person.position!.trim().isNotEmpty &&
                                                                        person.position!.toLowerCase() != 'null';
                    
                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          // color: Colors.red,
                                                                          // width: width ,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                person.name!,textAlign: TextAlign.start,
                                                                                style: GoogleFonts.raleway(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 14,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              if (hasPosition)
                                                                                Container(
                                                                                  // alignment: Alignment.centerLeft,
                                                                                  margin: const EdgeInsets.only(top: 4),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.blue.withAlpha(20),
                                                                                    borderRadius: BorderRadius.circular(4),
                                                                                  ),
                                                                                  child: Text(
                                                                                    person.position!.toUpperCase(),
                                                                                    style: GoogleFonts.raleway(
                                                                                      fontSize: 12,
                                                                                      color: Colors.blue[700],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 5),
                                                                      ],
                                                                    );
                                                                  }).toList(),
                    
                                                                  // Show company name with conditional style
                                                                  if (showCompanyName)
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                      child: Text(
                                                                        card.companyName!,
                                                                        style: GoogleFonts.raleway(
                                                                          fontWeight:
                                                                          validPersons.isEmpty ? FontWeight.w600 : FontWeight.w500,
                                                                          fontSize: 14,
                                                                          color: validPersons.isEmpty ? Colors.black : subtext,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                    
                    
                    
                    
                                                      ],
                                                    ),
                                                    Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .date_range,
                                                              color:
                                                              Colors
                                                                  .grey,
                                                            ),
                                                            Text(
                                                              card.createdAt!
                                                                  .substring(
                                                                0,
                                                                10,
                                                              ),
                                                              style: GoogleFonts.inter(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                                fontSize:
                                                                12,
                                                                color:
                                                                Colors
                                                                    .grey
                                                                    .shade700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                    
                                                        Row(
                                                          children: [
                                                            if(card.tag!=null && card.tag != '')
                                                              _buildSelectedItem(
                                                                card.tag!,
                                                                Icons.local_offer,
                                                                0,
                                                                true,
                                                              ),
                                                            Icon(
                                                              Icons
                                                                  .more_vert_outlined,
                                                            ),
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
                  ),
                  // SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                    decoration: BoxDecoration(
                      color: darkcolor,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '',
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
    );
  }

  Color _getDynamicColor(int index) {
    const List<Color> availableColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    return availableColors[index % availableColors.length];
  }

  Widget _buildSelectedItem(String name, IconData icon, int colorIndex, bool isTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getDynamicColor(colorIndex).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(icon, size: 16, color: _getDynamicColor(colorIndex)),
          SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(TOKEN);
    prefs.setBool(IS_LOGGED_IN, false);
    prefs.remove('loginResponse');
    // prefs.remove()
    // await prefs.clear();

    // appStore.setUser(null);
    appStore.setIsLogin(false);
    appStore.setUserToken(null);

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }
}
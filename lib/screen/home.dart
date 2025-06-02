import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:camera_app/api/CardApi.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/screen/add.dart';
import 'package:camera_app/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String? token;

  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();

  final outborder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.transparent),
    borderRadius: BorderRadius.circular(10),
  );

  List<CardDetails> _cards = [];
  List<DataCard> _cardapi = [];

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
  }

  Future<void> FetchCard() async {
    try {
      CardModel cardModel = await CardApi.getCard();
      if (cardModel.success == 1 && cardModel.data != null) {
        setState(() {
          _cardapi = cardModel.data!;
          isCardLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errormessage = "Something Went Wrong ==========>>>>>>>>>>>> $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadCard();
    FetchCard();
  }

  Future<void> _loadCard() async {
    final box = await Hive.openBox<CardDetails>('cardbox');
    setState(() {
      _cards = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return SafeArea(
      child: Scaffold(
        backgroundColor: screenBGColor,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
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
                Row(
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        width: width * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: nameController,
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
                    Card(
                      elevation: 10,
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Image.asset('assets/images/csvicon.png'),
                      ),
                    ),
                    SizedBox(width: 5),
                    Card(
                      elevation: 10,
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Icon(Icons.filter_alt, color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                Container(
                  color: Colors.white,
                  width: width,
                  height: height * 0.6,
                  child: Column(
                    children: [
                      SizedBox(height: 10),

                      Expanded(
                        child:
                            isCardLoading
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                  itemCount: _cardapi.length,
                                  itemBuilder: (context, index) {
                                    final card = _cardapi[index];
                                    final frontImageBytes =
                                        card.cardFrontImageBase64 != null &&
                                                card
                                                    .cardFrontImageBase64!
                                                    .isNotEmpty
                                            ? decodeBase64Image(
                                              card.cardFrontImageBase64!,
                                            )
                                            : null;

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 10,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => DetailsScreen(
                                                      dataCard: card,
                                                    ),
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
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child:
                                                          frontImageBytes !=
                                                                  null
                                                              ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                                child: Image.memory(
                                                                  frontImageBytes,
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                ),
                                                              )
                                                              : Icon(
                                                                Icons.image,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                size: 40,
                                                              ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            card.companyName
                                                                    ?.toString() ??
                                                                'No data',
                                                            style:
                                                                GoogleFonts.raleway(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                          ),
                                                          Text(
                                                            card.companyAddress!
                                                                    .join(
                                                                      ',',
                                                                    ) ??
                                                                "No Data",
                                                            style:
                                                                GoogleFonts.raleway(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 11,
                                                                  color:
                                                                      subtext,
                                                                ),
                                                          ),
                                                        ],
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
                                                          Icons.date_range,
                                                          color: Colors.grey,
                                                        ),
                                                        Text(
                                                          card.createdAt!
                                                              .substring(0, 10),
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
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
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            'General',
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
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
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDetails()),
            );
            _loadCard();
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blue,
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
// ),

import 'dart:convert';
import 'dart:typed_data';

import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/screen/editdetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';

import '../db/hive_card.dart';

class DetailsScreen extends StatefulWidget {
  // final CardDetails cardDetails;
  DataCard dataCard;

  // final int index;
  DetailsScreen({super.key,
    required this.dataCard,
    // required this.cardDetails,
    // required this.index
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

List<CardDetails> _cards = [];

class _DetailsScreenState extends State<DetailsScreen> {

  Future<void> _loadCard() async {
    final box = await Hive.openBox<CardDetails>('cardbox');
    setState(() {
      _cards = box.values.toList();
    });
  }

  void _deleteCardhive(dynamic id) async {
    await HiveBoxes.deleteCard(id);
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery
        .of(context)
        .size
        .width * 1;
    final height = MediaQuery
        .of(context)
        .size
        .height * 1;

    List<Uint8List> images = [];
    Uint8List decodeBase64Image(String base64String) {
      final cleanBase64 = base64String.split(',').last;
      return base64Decode(cleanBase64);
    }

    if (widget.dataCard.cardFrontImageBase64 != null &&
        widget.dataCard.cardFrontImageBase64!.isNotEmpty &&
        widget.dataCard.cardFrontImageBase64!.startsWith('data:image/')) {
      images.add(decodeBase64Image(widget.dataCard.cardFrontImageBase64!));
    }

    if (widget.dataCard.cardBackImageBase64 != null &&
        widget.dataCard.cardBackImageBase64!.isNotEmpty &&
        widget.dataCard.cardBackImageBase64!.startsWith('data:image/')) {
      images.add(decodeBase64Image(widget.dataCard.cardBackImageBase64!));
    }
    print('Front starts with: ${widget.dataCard.cardFrontImageBase64?.substring(0, 30)}');
    print('Back starts with: ${widget.dataCard.cardBackImageBase64?.substring(0, 30)}');

    print('Front image length: ${widget.dataCard.cardFrontImageBase64?.length}');
    print('Back image length: ${widget.dataCard.cardBackImageBase64?.length}');

    return Scaffold(
        backgroundColor: screenBGColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          // <- This disables tinting
          shadowColor: Colors.black.withValues(alpha: 1),
          // manually define shadow
          elevation: 10,
          backgroundColor: screenBGColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            // widget.!.fullname!,
            widget.dataCard.companyName.toString(),
            style: GoogleFonts.raleway(
                fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),

        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Center(
              child: Container(
              alignment: Alignment.center,
                color: Colors.grey.shade300,
                height: height * 0.2,
                width: width * 0.65,
                child: images.isNotEmpty?
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                  ),
                  items: images.map((imgBytes) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              imgBytes, // ✅ Corrected: use actual image bytes
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
                    :
                Icon(Icons.image, color: Colors.grey),
              )
              ),
            SizedBox(height: 20),

            Container(
              // color: Colors.red,
              width: width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add button
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_alt_outlined,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Add',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: HexColor('#639766'),
                        ),
                      ),
                    ],
                  ),

                  // Share button
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.share, color: HexColor('#3380B6')),
                      ),
                      Text(
                        'Share',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: HexColor('#3380B6'),
                        ),
                      ),
                    ],
                  ),

                  // Edit button
                  InkWell(
                    onTap: () async {
                      // final result =  await
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=> EditDetails(cardDetails: widget.cardDetails,
                      //     index:widget.index)));
                      // if(result == true){
                      // Navigator.pop(context , true);
                      // }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            color: HexColor('#000000'),
                          ),
                        ),
                        Text(
                          'Edit',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: HexColor('#00000'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  InkWell(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text('Delete Card'),
                              content: Text(
                                  'Are you sure you want to delete this card?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                      );

                      // if (confirm == true) {
                      //   final box = await Hive.openBox<CardDetails>('cardbox');
                      //   await box.deleteAt(widget.index); // Delete using index
                      //   Navigator.pop(context, true); // Pop and return true to refresh previous screen
                      // }
                    },

                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: HexColor('903034'),
                          ),
                        ),
                        Text(
                          'Delete',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: HexColor('903034'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Card Details And Genral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card Details',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(5),
                  // width: 100,
                  decoration: BoxDecoration(
                    color: HexColor('#386BF6'),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle
                  ),
                  child: Text(
                    'General',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

                  if (widget.dataCard.personDetails != null && widget.dataCard.personDetails!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'People:',
                          style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ...widget.dataCard.personDetails!.map((person) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("👤 Name: ${person.name ?? 'N/A'}"),
                              Text("📞 Phone: ${person.phoneNumber ?? 'N/A'}"),
                              Text("📧 Email: ${person.email ?? 'N/A'}"),
                              Text("💼 Position: ${person.position ?? 'N/A'}"),
                            ],
                          ),
                        )),
                      ],
                    ),


                  // Card
                  /*  Container(
                // color: Colors.red,
                child: Card(
                  elevation: 5,
                  child: Container(
                    color: screenBGColor,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // fullName
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 30,
                              color: HexColor('#222222'),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Full Name',
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  // widget.cardDetails!.fullname!,
                                  'null',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        // Email
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 30,
                                  color: HexColor('#222222'),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      'Email Address',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      // widget.cardDetails!.email!,

                                      'null',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Icon(Icons.send, color: HexColor('#5AA465')),
                          ],
                        ),
                        Divider(),
                        // companyName
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/images/buildingicon.png',
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Comapany Name',
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  // widget.cardDetails!.companyname!,
                                  'null',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        // phoneNumber
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 30,
                                  color: HexColor('#222222'),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      // widget.cardDetails!.number!,
                                      'null',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset('assets/images/whatsappicon.png'),),
                                SizedBox(width: 5,),
                                Icon(Icons.call, color: HexColor('#5AA465')),
                              ],
                            ),
                          ],
                        ),
                        Divider(),

                        // address
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: HexColor('#222222'),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                              textAlign: TextAlign.start,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                // widget.cardDetails!.address!,
                                  '',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),*/

                ],
    ),
    ),
    ),
    );
  }
}

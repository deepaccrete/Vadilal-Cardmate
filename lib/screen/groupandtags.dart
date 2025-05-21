import 'package:camera_app/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class GroupAndTags extends StatefulWidget {
  const GroupAndTags({super.key});

  @override
  State<GroupAndTags> createState() => _GroupAndTagsState();
}

class _GroupAndTagsState extends State<GroupAndTags> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: screenBGColor,
      appBar: AppBar(
        // elevation: 10,
        backgroundColor: screenBGColor,
        // shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        title: Text(
          'Group & Tags',
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                 Image.asset('assets/images/group-users 1.png',height: 50,),
                  SizedBox(width: 10),
                  Flexible(

                    child: Text(
                      'Groups',
                      style: GoogleFonts.raleway(
                        color: primarycolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              // cards
              Row(
                children: [
                  // icon
                  Flexible(
                    fit: FlexFit.loose,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        width: width * 0.3,
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                        ),
                        child: Icon(
                          Icons.group_add,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  // mycard
                  Flexible(
                    fit: FlexFit.loose,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: width * 0.3,
                        height: height * 0.15,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          // shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),

                                    color: Colors.blue.shade100,
                                    // shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    'MC',
                                    style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      color: HexColor('#3259C2'),
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.grey,
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            Text(
                              'My Cards',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              '0',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Tags
              Row(
                children: [
                Image.asset('assets/images/price.png',height: 50,),
                  SizedBox(width: 10),
                  Text(
                    'Tags',
                    style: GoogleFonts.raleway(
                      color: primarycolor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.15,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.add),
                  ),

                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: width * 0.25,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'General',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: width * 0.25,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Prospect',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),

                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: width * 0.2,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Trial',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: width * 0.2,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Trial',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: width * 0.2,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Lead',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: width * 0.25,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: HexColor('E5E5E5'),
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Partner',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
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

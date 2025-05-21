import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return SafeArea(
      child: Scaffold(
        backgroundColor: screenBGColor,
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.red,
            // margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                // Name
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        // color: Colors.red,
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
                // Search textform
                Row(
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   )
                          // ],
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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     offset: Offset(0.0, 0.0),
                          //     blurRadius: 0.0,
                          //     spreadRadius: 0.0,
                          //   )
                          // ],
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Icon(Icons.filter_alt, color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                // No card Found
                // Container(
                //   // color: Colors.red,
                //   width: width,
                //   height:  height * 0.6,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Icons.person_search,size: 100,color: Colors.grey.shade300,),
                //       Text('No Card Found',style: GoogleFonts.poppins(color: Colors.grey.shade400,fontSize: 14),)
                //     ],
                //   ),
                // ),
                Container(
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
                                                'XYZ Person',
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
                                                'Location of dummy, address of dummy, location map, directions to dummy',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

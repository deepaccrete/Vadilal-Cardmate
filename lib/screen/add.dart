import 'package:camera_app/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../componets/button.dart';
import '../componets/textform.dart';
import '../constant/colors.dart';
import 'groupandtags.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({super.key});

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {


  final TextEditingController  nameController = TextEditingController();
  final TextEditingController  designationController = TextEditingController();
  final TextEditingController  phoneController = TextEditingController();
  final TextEditingController  emailController = TextEditingController();
  final TextEditingController  companynameController = TextEditingController();
  final TextEditingController  addressController = TextEditingController();
  final TextEditingController  webController = TextEditingController();
  final TextEditingController  noteController = TextEditingController();


  List<dynamic> listdata = [];


  void _addData(){
    if(nameController.text.isNotEmpty || designationController.text.isNotEmpty|| phoneController.text.isNotEmpty||emailController.text.isNotEmpty||
    companynameController.text.isNotEmpty || addressController.text.isNotEmpty
    ){
      setState(() {
        listdata.add({
          "name": nameController.text,
          "Designation": designationController.text,
          "phone": phoneController.text,
          "emaill": emailController.text,
          "companyname": companynameController.text,
          "address": addressController.text,
          "web": webController.text,
          "note": noteController.text
        });
      });
    }
    _gotohome();
  }


  void _gotohome(){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen(datalist: listdata,)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent, // <- This disables tinting
        shadowColor: Colors.black.withValues(alpha: 1), // manually define shadow
        backgroundColor: screenBGColor,
        elevation: 10,
        centerTitle:true,
        title: Text('Add Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //text card
              Text(
                'Card Front',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              // img
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.2,
                  width: width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300,

                  ),
                  child: Icon(Icons.image, color: Colors.grey),
                ),
              ),

              // Card Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card Details',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              Card(
                // surfaceTintColor: Colors.transparent, // <- This disables tinting
                shadowColor: Colors.black.withValues(alpha: 1,), // manually define shadow
                elevation: 20,
                color: Colors.black,
                child: Container(
                  color: screenBGColor,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Bussiness Tags',
                      //   style: GoogleFonts.inter(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 14,
                      //   ),
                      // ),
                      //
                      // // General
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => GroupAndTags(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 10,
                      //       vertical: 5,
                      //     ),
                      //     height: height * 0.06,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.grey),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           'General',
                      //           style: GoogleFonts.poppins(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //         Icon(Icons.keyboard_arrow_down),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Text(
                        'Full Name',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: nameController,
                        heightTextform: height * 0.06,
                        hintText: 'XYZ Person',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.person_outline),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      Text(
                        'Designation',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: phoneController,
                        heightTextform: height * 0.06,
                        hintText: 'XYZ ',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.account_box),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),
                      // Phone
                      Text(
                        'Phone Number',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: phoneController,
                        heightTextform: height * 0.06,
                        hintText: '9999999999',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.call_outlined),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      // email
                      Text(
                        'Email',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: emailController,
                        heightTextform: height * 0.06,
                        hintText: 'abc@gmail.com',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.email_outlined),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      // Comapny Name
                      Text(
                        'Company Name',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: companynameController,
                        heightTextform: height * 0.06,
                        hintText: 'XYZ',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.maps_home_work_outlined),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      // Address
                      Text(
                        'Address',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: addressController,
                        heightTextform: height * 0.06,
                        hintText: 'Address',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.location_pin),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      // Company WebSite
                      Text(
                        'Comapany Website',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: webController,
                        heightTextform: height * 0.06,
                        hintText: 'www.xyz.com',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.web),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),

                      // Note
                      Text(
                        'Note',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      CommonTextForm(
                        controller: noteController,
                        maxline: 2,
                        heightTextform: height * 0.1,
                        hintText: 'Notes',
                        borderc: 10,
                        BorderColor: Colors.grey,
                        icon: Icon(Icons.note_alt_outlined),
                        obsecureText: false,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              CommonButton(
                height: height * 0.06,
                bordercircular: 20,
                onTap: (){
                  _addData();
                },
                child: Text(
                  'Add Details',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}






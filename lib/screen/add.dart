import 'dart:io';

import 'package:camera_app/db/hive_card.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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


  final TextEditingController  nameController        = TextEditingController();
  final TextEditingController  designationController = TextEditingController();
  final TextEditingController  phoneController       = TextEditingController();
  final TextEditingController  emailController       = TextEditingController();
  final TextEditingController  companynameController = TextEditingController();
  final TextEditingController  addressController     = TextEditingController();
  final TextEditingController  webController         = TextEditingController();
  final TextEditingController  noteController        = TextEditingController();

  FocusNode namenode = FocusNode();
  FocusNode desinationnode = FocusNode();
  FocusNode phonenode = FocusNode();
  FocusNode emailnode = FocusNode();
  FocusNode companynamenode = FocusNode();
  FocusNode addressnode = FocusNode();
  FocusNode webnode = FocusNode();
  FocusNode notenode = FocusNode();

  List<Map<String, dynamic>> listdata = [];

  final _formkey = GlobalKey<FormState>();


  // function to add data in hive
  Future<void> _addcardtoHive()async{
    if(_formkey.currentState!.validate()){
      final newCard = CardDetails(
          id: Uuid().v4().toString(),
          fullname:nameController.text,
          designation: designationController.text,
          number: phoneController.text,
          email: emailController.text,
          companyname: companynameController.text,
          address: addressController.text,
          website: webController.text,
          note: noteController.text,
      );


      await HiveBoxes.addCard(newCard);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Card Saved SuccessFully!'))
      // );
      _gotohome();
      // dispose();

    }
  }

  void dispose(){
    nameController.dispose();
    designationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companynameController.dispose();
    addressController.dispose();
    webController.dispose();
    noteController.dispose();
    namenode.dispose();
    desinationnode.dispose();
    phonenode.dispose();
    emailnode.dispose();
    companynamenode.dispose();
    addressnode.dispose();
    webnode.dispose();
    notenode.dispose();


    super.dispose();
  }

  void _gotohome(){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen(
      // datalist: listdata,
    )));
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
                  child: Form(
                    key: _formkey,
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
                          focusNode: namenode,
                          controller: nameController,
                          heightTextform: height * 0.06,
                          hintText: 'XYZ Person',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.person_outline),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Name";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(desinationnode);
                          },
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
                          focusNode: desinationnode,
                          controller: designationController,
                          heightTextform: height * 0.06,
                          hintText: 'XYZ ',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.account_box),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Designation";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(phonenode);
                          },

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
                          focusNode: phonenode,
                          controller: phoneController,
                          heightTextform: height * 0.06,
                          hintText: '9999999999',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.call_outlined),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Mobile Number";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(emailnode);
                          },
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
focusNode: emailnode,
                          controller: emailController,
                          heightTextform: height * 0.06,
                          hintText: 'abc@gmail.com',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.email_outlined),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter email";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(companynamenode);
                          },
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
                          focusNode: companynamenode,
                          controller: companynameController,
                          heightTextform: height * 0.06,
                          hintText: 'XYZ',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.maps_home_work_outlined),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter CompanyName";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(addressnode);
                          },
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
                          focusNode: addressnode,
                          controller: addressController,
                          heightTextform: height * 0.06,
                          hintText: 'Address',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.location_pin),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Address";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(webnode
                            );
                          },
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
                          focusNode: webnode,
                          controller: webController,
                          heightTextform: height * 0.06,
                          hintText: 'www.xyz.com',
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.web),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Website";
                            }
                          },
                          onfieldsumbitted: (value){
                            FocusScope.of(context).requestFocus(notenode);
                          },
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
                          focusNode: notenode,
                          contentpadding: 20,
                          controller: noteController,
                          maxline: 5,
                    
                          heightTextform: height * 0.1,
                          hintText: 'Notes',
                    
                          borderc: 10,
                          BorderColor: Colors.grey,
                          icon: Icon(Icons.note_alt_outlined),
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please Enter Note";
                            }
                          },
                        ),
                        SizedBox(height: 10),



                        CommonButton(
                          height: height * 0.06,
                          bordercircular: 20,
                          onTap: (){
                            if(_formkey.currentState!.validate()){
                              _addcardtoHive();
                            }
                            // _addcardtoHive();
                            // _addData();
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
              ),


            ],
          ),
        ),
      ),

    );
  }
}











//list
// import 'package:camera_app/screen/home.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../componets/button.dart';
// import '../componets/textform.dart';
// import '../constant/colors.dart';
// import 'groupandtags.dart';
//
// class AddDetails extends StatefulWidget {
//   const AddDetails({super.key});
//
//   @override
//   State<AddDetails> createState() => _AddDetailsState();
// }
//
// class _AddDetailsState extends State<AddDetails> {
//
//
//   final TextEditingController  nameController = TextEditingController();
//   final TextEditingController  designationController = TextEditingController();
//   final TextEditingController  phoneController = TextEditingController();
//   final TextEditingController  emailController = TextEditingController();
//   final TextEditingController  companynameController = TextEditingController();
//   final TextEditingController  addressController = TextEditingController();
//   final TextEditingController  webController = TextEditingController();
//   final TextEditingController  noteController = TextEditingController();
//
//
//   List<dynamic> listdata = [];
//
//
//   void _addData(){
//     if(nameController.text.isNotEmpty || designationController.text.isNotEmpty|| phoneController.text.isNotEmpty||emailController.text.isNotEmpty||
//     companynameController.text.isNotEmpty || addressController.text.isNotEmpty
//     ){
//       setState(() {
//         listdata.add({
//           "name": nameController.text,
//           "Designation": designationController.text,
//           "phone": phoneController.text,
//           "emaill": emailController.text,
//           "companyname": companynameController.text,
//           "address": addressController.text,
//           "web": webController.text,
//           "note": noteController.text
//         });
//       });
//     }
//     _gotohome();
//   }
//
//
//   void _gotohome(){
//     Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen(datalist: listdata,)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width * 1;
//     final height = MediaQuery.of(context).size.height * 1;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent, // <- This disables tinting
//         shadowColor: Colors.black.withValues(alpha: 1), // manually define shadow
//         backgroundColor: screenBGColor,
//         elevation: 10,
//         centerTitle:true,
//         title: Text('Add Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //text card
//               Text(
//                 'Card Front',
//                 style: GoogleFonts.raleway(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                 ),
//               ),
//               // img
//               Center(
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: height * 0.2,
//                   width: width * 0.6,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey.shade300,
//
//                   ),
//                   child: Icon(Icons.image, color: Colors.grey),
//                 ),
//               ),
//
//               // Card Details
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Card Details',
//                     style: GoogleFonts.raleway(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//
//               Card(
//                 // surfaceTintColor: Colors.transparent, // <- This disables tinting
//                 shadowColor: Colors.black.withValues(alpha: 1,), // manually define shadow
//                 elevation: 20,
//                 color: Colors.black,
//                 child: Container(
//                   color: screenBGColor,
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Text(
//                       //   'Bussiness Tags',
//                       //   style: GoogleFonts.inter(
//                       //     fontWeight: FontWeight.w600,
//                       //     fontSize: 14,
//                       //   ),
//                       // ),
//                       //
//                       // // General
//                       // InkWell(
//                       //   onTap: () {
//                       //     Navigator.push(
//                       //       context,
//                       //       MaterialPageRoute(
//                       //         builder: (context) => GroupAndTags(),
//                       //       ),
//                       //     );
//                       //   },
//                       //   child: Container(
//                       //     padding: EdgeInsets.symmetric(
//                       //       horizontal: 10,
//                       //       vertical: 5,
//                       //     ),
//                       //     height: height * 0.06,
//                       //     decoration: BoxDecoration(
//                       //       borderRadius: BorderRadius.circular(10),
//                       //       border: Border.all(color: Colors.grey),
//                       //     ),
//                       //     child: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //       children: [
//                       //         Text(
//                       //           'General',
//                       //           style: GoogleFonts.poppins(
//                       //             fontSize: 12,
//                       //             fontWeight: FontWeight.w500,
//                       //           ),
//                       //         ),
//                       //         Icon(Icons.keyboard_arrow_down),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//
//                       Text(
//                         'Full Name',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: nameController,
//                         heightTextform: height * 0.06,
//                         hintText: 'XYZ Person',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.person_outline),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       Text(
//                         'Designation',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: designationController,
//                         heightTextform: height * 0.06,
//                         hintText: 'XYZ ',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.account_box),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//                       // Phone
//                       Text(
//                         'Phone Number',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: phoneController,
//                         heightTextform: height * 0.06,
//                         hintText: '9999999999',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.call_outlined),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       // email
//                       Text(
//                         'Email',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: emailController,
//                         heightTextform: height * 0.06,
//                         hintText: 'abc@gmail.com',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.email_outlined),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Comapny Name
//                       Text(
//                         'Company Name',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: companynameController,
//                         heightTextform: height * 0.06,
//                         hintText: 'XYZ',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.maps_home_work_outlined),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Address
//                       Text(
//                         'Address',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: addressController,
//                         heightTextform: height * 0.06,
//                         hintText: 'Address',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.location_pin),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Company WebSite
//                       Text(
//                         'Comapany Website',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         controller: webController,
//                         heightTextform: height * 0.06,
//                         hintText: 'www.xyz.com',
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.web),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Note
//                       Text(
//                         'Note',
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       CommonTextForm(
//                         contentpadding: 20,
//                         controller: noteController,
//                         maxline: 5,
//
//                         heightTextform: height * 0.1,
//                         hintText: 'Notes',
//
//                         borderc: 10,
//                         BorderColor: Colors.grey,
//                         icon: Icon(Icons.note_alt_outlined),
//                         obsecureText: false,
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//
//               CommonButton(
//                 height: height * 0.06,
//                 bordercircular: 20,
//                 onTap: (){
//                   _addData();
//                 },
//                 child: Text(
//                   'Add Details',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
//
//
//
//
//

import 'dart:io';

import 'package:camera_app/db/hive_card.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:universal_html/js_util.dart' as personNameControllers;
import 'package:universal_html/js_util.dart' as personMobileControllers;
// import 'package:uuid/uuid.dart';

import '../componets/button.dart';
import '../componets/textform.dart';
import '../constant/colors.dart';
import '../model/cardModel.dart';
import 'groupandtags.dart';

class EditCard extends StatefulWidget {
  DataCard? dataCard;
   EditCard({super.key ,  this.dataCard});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {


   TextEditingController  designationController = TextEditingController();
  TextEditingController  nameController        = TextEditingController();
  TextEditingController  phoneController       = TextEditingController();
   TextEditingController  emailController       = TextEditingController();
   TextEditingController  companynameController = TextEditingController();
   TextEditingController  addressController     = TextEditingController();
  TextEditingController  webController         = TextEditingController();
  TextEditingController  noteController        = TextEditingController();
   List<TextEditingController> personNameControllers = [];
   List<TextEditingController> personMobileControllers = [];
   List<TextEditingController> personEmailControllers = [];
   List<TextEditingController> personPositionControllers = [];

   List<FocusNode> personnameNode = [];
   List<FocusNode> personMobileNode = [];
   List<FocusNode> personEmailNode = [];
   List<FocusNode> personPositionNode = [];

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
 /* Future<void> _addcardtoHive()async{
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card Saved SuccessFully!'))
      );
      _gotohome();
      // dispose();

    }
  }*/

   @override
   void dispose()
   {
     // Single controllers
     nameController.dispose();
     designationController.dispose();
     phoneController.dispose();
     emailController.dispose();
     companynameController.dispose();
     addressController.dispose();
     webController.dispose();
     noteController.dispose();

     // Focus nodes
     namenode.dispose();
     desinationnode.dispose();
     phonenode.dispose();
     emailnode.dispose();
     companynamenode.dispose();
     addressnode.dispose();
     webnode.dispose();
     notenode.dispose();

     // Dispose dynamic lists
     for (var controller in personNameControllers) {
       controller.dispose();
     }
     for (var controller in personEmailControllers) {
       controller.dispose();
     }
     for (var controller in personMobileControllers) {
       controller.dispose();
     }
     for (var controller in personPositionControllers) {
       controller.dispose();
     }

     super.dispose();
   }

  void _gotohome(){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> Bottomnav(
      // datalist: listdata,
    )));
  }

@override
  void initState() {
    super.initState();
    for (var person in widget.dataCard?.personDetails ?? []) {
      personNameControllers.add(TextEditingController(text: person.name));
      personMobileControllers.add(TextEditingController(text: person.phoneNumber));
      personEmailControllers.add(TextEditingController(text: person.email));
      personPositionControllers.add(TextEditingController(text: person.position));

      personnameNode.add(FocusNode());
      personEmailNode.add(FocusNode());
      personMobileNode.add(FocusNode());
      personPositionNode.add(FocusNode());

    }
    if(personNameControllers.isEmpty){
      addemptyPerson();

    }
    companynameController = TextEditingController(text: widget.dataCard!.companyName);
    emailController = TextEditingController(text: widget.dataCard!.companyEmail);
    addressController = TextEditingController(
      text: widget.dataCard!.companyAddress?.join(', ') ?? '',
        // nameController = TextEditingController(text: widget.dataCard.personDetails)
  );


    // Initialize controllers for each person
    // for (var person in widget.dataCard?.personDetails ?? []) {
    //   personNameControllers.add(TextEditingController(text: person.name));
    //   personMobileControllers.add(TextEditingController(text: person.phoneNumber));
    // }

}
void addemptyPerson(){
      personNameControllers.add(TextEditingController());
      personEmailControllers.add(TextEditingController());
      personMobileControllers.add(TextEditingController());
      personPositionControllers.add(TextEditingController());
      personnameNode.add(FocusNode());
      personEmailNode.add(FocusNode());
      personMobileNode.add(FocusNode());
      personPositionNode.add(FocusNode());

      print('Names: ${personNameControllers.length}');
      print('Emails: ${personEmailControllers.length}');
      print('Mobiles: ${personMobileControllers.length}');
      print('Positions: ${personPositionControllers.length}');
}

   void removePerson(int index) {
     if (index < personNameControllers.length) {
       personNameControllers[index].dispose();
       personEmailControllers[index].dispose();
       personMobileControllers[index].dispose();
       personPositionControllers[index].dispose();

       personNameControllers.removeAt(index);
       personEmailControllers.removeAt(index);
       personMobileControllers.removeAt(index);
       personPositionControllers.removeAt(index);

       personnameNode[index].dispose();
       personEmailNode[index].dispose();
       personMobileNode[index].dispose();
       personPositionNode[index].dispose();

       personnameNode.removeAt(index);
       personEmailNode.removeAt(index);
       personMobileNode.removeAt(index);
       personPositionNode.removeAt(index);

       print('Removed person at index $index');
     }
   }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor:screenBGColor,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Card Front',
                            textAlign: TextAlign.start,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              // img
              Center(
                child: Container(
                  // alignment: Alignment.center,
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
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Text(
                  'Card Details',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                               ),
               ),

            Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // padding: EdgeInsets.all(5),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Person Details',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 16),),


                            personNameControllers.isEmpty?
                            InkWell(
                              onTap: (){
                            setState(() {
                              addemptyPerson();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Persone Added')));

                            });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text('ADD+',style: GoogleFonts.poppins(color: Colors.black),)),
                            )
                                :SizedBox()

                            // CommonButton(
                            //   bordercircular: 5,
                            //   width: width * 0.2,
                            //   height: height * 0.04,
                            //   child: Text('ADD+',style: GoogleFonts.poppins(color: Colors.white),),
                            //   onTap: (){
                            //   addemptyPersone();
                            //   setState(() {
                            //
                            //   });
                            //   },
                            // )
                          ],
                        ),

                        SizedBox(height: 5,),


                        ...List.generate(


                           // personNameControllers.isEmpty? 1 : personNameControllers.length,
                            personNameControllers.length,
                                (index){
                        return  Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Person ${index +1}',style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),),


                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                addemptyPerson();
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Person Added')));

                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text('ADD',style: GoogleFonts.poppins(color: Colors.black),)),
                                          ),
                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: (){
                                              setState(() {

                                                removePerson(index);

                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Person Removed')));

                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text('Remove ',style: GoogleFonts.poppins(color: Colors.black),)),
                                          ),
                                        ],
                                      ),

                                      // CommonButton(
                                      //   bordercircular: 5,
                                      //   width: width * 0.2,
                                      //   height: height * 0.04,
                                      //   child: Text('ADD+',style: GoogleFonts.poppins(color: Colors.white),),
                                      //   onTap: (){
                                      //   addemptyPersone();
                                      //   setState(() {
                                      //
                                      //   });
                                      //   },
                                      // )
                                    ],
                                  ),
                                  Card(
                                    elevation: 2,
                                    shadowColor: Colors.black12,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEF7FF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Full Name',
                                            style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CommonTextForm(
                                            fillColor: Colors.white,
                                            labelColor: Colors.black54,
                                            contentpadding: 10,
                                            focusNode: personnameNode[index],
                                            controller: personNameControllers[index],
                                            labeltext: 'Enter Name',
                                            borderc: 10,
                                            BorderColor: Colors.black26,
                                            icon: Icon(Icons.person_outline, color: Colors.black54),
                                            obsecureText: false,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Please enter Name";
                                              }
                                              return null;
                                            },
                                            onfieldsumbitted: (value) {
                                              FocusScope.of(context).requestFocus(desinationnode);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),





                                  SizedBox(height: 10),
                                  Card(
                                    elevation: 4,
                                    shadowColor: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEF7FF),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Designation',
                                            style: GoogleFonts.raleway(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CommonTextForm(
                                            fillColor: Colors.white,
                                            labelColor: Colors.black54,
                                            contentpadding: 10,
                                            focusNode: personPositionNode[index],
                                            controller: personPositionControllers[index],
                                            labeltext: 'Designation',
                                            borderc: 10,
                                            BorderColor: Colors.black26,
                                            icon: Icon(Icons.work_outline, color: Colors.black54),
                                            obsecureText: false,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Please enter designation";
                                              }
                                              return null;
                                            },
                                            onfieldsumbitted: (value) {
                                              FocusScope.of(context).nextFocus();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),



                                  SizedBox(height: 10),

                                  // Phone Number Card
                                  Card(
                                    elevation: 4,
                                    shadowColor: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEF7FF),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Phone Number',
                                            style: GoogleFonts.raleway(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CommonTextForm(
                                            fillColor: Colors.white,
                                            labelColor: Colors.black54,
                                            contentpadding: 10,
                                            focusNode: personMobileNode[index],
                                            controller: personMobileControllers[index],
                                            labeltext: 'Enter phone number',
                                            borderc: 10,
                                            BorderColor: Colors.black26,
                                            icon: Icon(Icons.phone, color: Colors.black54),
                                            obsecureText: false,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Please enter phone number";
                                              }
                                              return null;
                                            },
                                            onfieldsumbitted: (value) {
                                              FocusScope.of(context).requestFocus(desinationnode);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // Designation Card
                                  //                         Card(
                                  //                           surfaceTintColor: Colors.transparent,
                                  //                           shadowColor: Colors.black.withValues(alpha: 1),
                                  //                           elevation: 4,
                                  //                           // shadowColor: Colors.black26,
                                  //                           shape: RoundedRectangleBorder(
                                  //                             borderRadius: BorderRadius.circular(15),
                                  //                           ),
                                  //                           child: Container(
                                  //                             padding: EdgeInsets.all(20),
                                  //                             decoration: BoxDecoration(
                                  //                               color: Color(0xFFFEF7FF),
                                  //                               borderRadius: BorderRadius.circular(15),
                                  //                             ),
                                  //                             child: Column(
                                  //                               crossAxisAlignment: CrossAxisAlignment.start,
                                  //                               children: [
                                  //                                 Text(
                                  //                                   'Designation',
                                  //                                   style: GoogleFonts.raleway(
                                  //                                     fontSize: 15,
                                  //                                     color: Colors.black87,
                                  //                                     fontWeight: FontWeight.bold,
                                  //                                   ),
                                  //                                 ),
                                  //                                 SizedBox(height: 10),
                                  //                                 CommonTextForm(
                                  //                                   fillColor: Colors.white,
                                  //                                   labelColor: Colors.black54,
                                  //                                   contentpadding: 10,
                                  //                                   focusNode: desinationnode,
                                  //                                   controller: designationController,
                                  //                                   labeltext: 'Enter designation',
                                  //                                   borderc: 10,
                                  //                                   BorderColor: Colors.black26,
                                  //                                   icon: Icon(Icons.work_outline, color: Colors.black54),
                                  //                                   obsecureText: false,
                                  //                                   validator: (value) {
                                  //                                     if (value == null || value.isEmpty) {
                                  //                                       return "Please enter designation";
                                  //                                     }
                                  //                                     return null;
                                  //                                   },
                                  //                                   onfieldsumbitted: (value) {
                                  //                                     FocusScope.of(context).nextFocus();
                                  //                                   },
                                  //                                 )
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                         ),


                                  // SizedBox(height: 10),
                                  // // Phone
                                  // Card(
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       color: Color(0xFFA29BFE),
                                  //
                                  //     ),
                                  //     padding: EdgeInsets.all(10),
                                  //     child: Column(
                                  //      crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           'Phone Number',
                                  //           style: GoogleFonts.raleway(
                                  //             fontSize: 14,
                                  //             color: Colors.grey[700],
                                  //             fontWeight: FontWeight.w600,
                                  //           ),
                                  //         ),
                                  //         // Row(
                                  //         //   children: [
                                  //         //     // Container(
                                  //         //     //   width: 40,
                                  //         //     //   height: 40,
                                  //         //     //   decoration: BoxDecoration(
                                  //         //     //     color: Colors.blue.withValues(alpha: 0.1),
                                  //         //     //     borderRadius: BorderRadius.circular(8),
                                  //         //     //   ),
                                  //         //     //   child: Icon(
                                  //         //     //     Icons.phone,
                                  //         //     //     // color: Colors.blue[700],
                                  //         //     //     color: primarycolor,
                                  //         //     //     size: 20,
                                  //         //     //   ),
                                  //         //     // ),
                                  //         //     SizedBox(width: 5,),
                                  //         //
                                  //         //   ],
                                  //         // ),
                                  //         SizedBox(height: 5),
                                  //         CommonTextForm(  symetric: true,
                                  //           fillColor: Colors.grey[200],
                                  //           labelColor: Colors.grey[600],
                                  //           contentpadding: 5,
                                  //           focusNode: phonenode,
                                  //           controller: phoneController,
                                  //           // heightTextform: height * 0.06,
                                  //           labeltext: 'MobileNo',
                                  //           borderc: 10,
                                  //           BorderColor: Colors.grey,
                                  //           icon: Icon(Icons.call_outlined,color: primarycolor,),
                                  //           obsecureText: false,
                                  //           validator: (value) {
                                  //             if (value == null || value.isEmpty) {
                                  //               return "please Enter Mobile Number";
                                  //             }
                                  //           },
                                  //           onfieldsumbitted: (value){
                                  //             FocusScope.of(context).requestFocus(emailnode);
                                  //           },
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 10),

                                  // email
                                  // Email Card
                                  Card(
                                    elevation: 4,
                                    shadowColor: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEF7FF),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email',
                                            style: GoogleFonts.raleway(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CommonTextForm(
                                            fillColor: Colors.white,
                                            labelColor: Colors.black54,
                                            contentpadding: 10,
                                            focusNode: personEmailNode[index],
                                            controller: personEmailControllers[index],
                                            labeltext: 'Enter email',
                                            borderc: 10,
                                            BorderColor: Colors.black26,
                                            icon: Icon(Icons.email_outlined, color: Colors.black54),
                                            obsecureText: false,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Please enter email";
                                              }
                                              return null;
                                            },
                                            onfieldsumbitted: (value) {
                                              FocusScope.of(context).requestFocus(companynamenode);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        }),

                        SizedBox(height: 10),
                        Text('Company Details',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),),

// Company Name Card
                        Card(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEF7FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Name',
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CommonTextForm(
                                  fillColor: Colors.white,
                                  labelColor: Colors.black54,
                                  contentpadding: 10,
                                  focusNode: companynamenode,
                                  controller: companynameController,
                                  labeltext: 'Enter company name',
                                  borderc: 10,
                                  BorderColor: Colors.black26,
                                  icon: Icon(Icons.maps_home_work_outlined, color: Colors.black54),
                                  obsecureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter company name";
                                    }
                                    return null;
                                  },
                                  onfieldsumbitted: (value) {
                                    FocusScope.of(context).requestFocus(addressnode);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Address
                        // Address Card
                        Card(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEF7FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CommonTextForm(
                                  fillColor: Colors.white,
                                  labelColor: Colors.black54,
                                  contentpadding: 10,
                                  focusNode: addressnode,
                                  controller: addressController,
                                  labeltext: 'Enter address',
                                  borderc: 10,
                                  BorderColor: Colors.black26,
                                  icon: Icon(Icons.location_pin, color: Colors.black54),
                                  obsecureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter address";
                                    }
                                    return null;
                                  },
                                  onfieldsumbitted: (value) {
                                    FocusScope.of(context).requestFocus(webnode);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

// Company Website Card
                        Card(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEF7FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Website',
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CommonTextForm(
                                  fillColor: Colors.white,
                                  labelColor: Colors.black54,
                                  contentpadding: 10,
                                  focusNode: webnode,
                                  controller: webController,
                                  labeltext: 'Enter website',
                                  borderc: 10,
                                  BorderColor: Colors.black26,
                                  icon: Icon(Icons.web, color: Colors.black54),
                                  obsecureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter website";
                                    }
                                    return null;
                                  },
                                  onfieldsumbitted: (value) {
                                    FocusScope.of(context).requestFocus(notenode);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

// Note Card
                        Card(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEF7FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Note',
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CommonTextForm(
                                  fillColor: Colors.white,
                                  labelColor: Colors.black54,
                                  contentpadding: 10,
                                  focusNode: notenode,
                                  controller: noteController,
                                  maxline: 5,
                                  labeltext: 'Enter note',
                                  borderc: 10,
                                  BorderColor: Colors.black26,
                                  icon: Icon(Icons.note_alt_outlined, color: Colors.black54),
                                  obsecureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter note";
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),



                        CommonButton(
                          height: height * 0.06,
                          bordercircular: 20,
                          onTap: (){
                            // if(_formkey.currentState!.validate()){
                            //   _addcardtoHive();
                            // }
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

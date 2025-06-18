import 'package:camera_app/api/TagApi.dart';
import 'package:camera_app/model/TagModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../componets/button.dart';
import '../componets/textform.dart';
import '../constant/colors.dart';

class AddManual extends StatefulWidget {
  const AddManual({super.key});

  @override
  State<AddManual> createState() => _AddManualState();
}

// class _AddManualState extends State<AddManual> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Add Mnual'),);
//   }
// }

class _AddManualState extends State<AddManual> {

  TextEditingController  designationController = TextEditingController();
  TextEditingController  nameController        = TextEditingController();
  TextEditingController  phoneController       = TextEditingController();
  TextEditingController  emailController       = TextEditingController();
  TextEditingController  companyemailController       = TextEditingController();
  TextEditingController  companynameController = TextEditingController();
  TextEditingController  addressController     = TextEditingController();
  TextEditingController  webController         = TextEditingController();
  TextEditingController  noteController        = TextEditingController();
  List<TextEditingController> personNameControllers = [];
  List<TextEditingController> personMobileControllers = [];
  List<TextEditingController> personEmailControllers = [];
  List<TextEditingController> personPositionControllers = [];

  FocusNode namenode = FocusNode();
  FocusNode desinationnode = FocusNode();
  FocusNode phonenode = FocusNode();
  FocusNode emailnode = FocusNode();
  FocusNode companynamenode = FocusNode();
  FocusNode addressnode = FocusNode();
  FocusNode webnode = FocusNode();
  FocusNode notenode = FocusNode();

  List<Map<String, dynamic>> listdata = [];

  List<Datatag> taglist = [];
  Datatag ? selectedTag;
   String? errormsg;
   bool istagLoading = true;


   final _formkey = GlobalKey<FormState>();


  Future<void> FetchTag ()async{
     // istagLoading = true;
    try{
      TagModel tagModel = await TagApi.getTag();
      if(tagModel.success == 1 && tagModel.data != null){
        setState(() {
          taglist = tagModel.data!;
          istagLoading =false;
        });
      }else{
        setState(() {
          errormsg = 'Api Not Working';
          istagLoading = false;
        });
      }
    }catch(e){
      print('something Went Wrong => $e');

    }finally{
      setState(() {
        istagLoading = false;
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  FetchTag();
  }
  // function to add data in hive
  // Future<void> _addcardtoHive()async{
  //   if(_formkey.currentState!.validate()){
  //     final newCard = CardDetails(
  //       id: Uuid().v4().toString(),
  //       fullname:nameController.text,
  //       designation: designationController.text,
  //       number: phoneController.text,
  //       email: emailController.text,
  //       companyname: companynameController.text,
  //       address: addressController.text,
  //       website: webController.text,
  //       note: noteController.text,
  //     );
  //
  //
  //     await HiveBoxes.addCard(newCard);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Card Saved SuccessFully!'))
  //     );
  //     _gotohome();
  //     // dispose();
  //
  //   }
  // }

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

  // void _gotohome(){
  //   Navigator.push(context,MaterialPageRoute(builder: (_)=> Bottomnav(
  //     // datalist: listdata,
  //   )));
  // }

  @override
  // void initState() {
  //   super.initState();
  //
  //   for (var person in widget.dataCard?.personDetails ?? []) {
  //     personNameControllers.add(TextEditingController(text: person.name));
  //     personMobileControllers.add(TextEditingController(text: person.phoneNumber));
  //     personEmailControllers.add(TextEditingController(text: person.email));
  //     personPositionControllers.add(TextEditingController(text: person.position));
  //   }
  //   companynameController = TextEditingController(text: widget.dataCard!.companyName);
  //   emailController = TextEditingController(text: widget.dataCard!.companyEmail);
  //   addressController = TextEditingController(
  //     text: widget.dataCard!.companyAddress?.join(', ') ?? '',
  //     // nameController = TextEditingController(text: widget.dataCard.personDetails)
  //   );
  //
  //
  //   // Initialize controllers for each person
  //   // for (var person in widget.dataCard?.personDetails ?? []) {
  //   //   personNameControllers.add(TextEditingController(text: person.name));
  //   //   personMobileControllers.add(TextEditingController(text: person.phoneNumber));
  //   // }
  //
  // }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
      
                Card(
                  child: Container(
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
                          Text('Person Details',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 16),),
                  
                          SizedBox(height: 5,),
                          // select Tag
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
                                    'Select Tag',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  taglist.isEmpty?
                                  CircularProgressIndicator():
                                  Container(
                                    padding:EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(width:2,color:Colors.grey.shade200),
                                      color: Colors.white,
                                      borderRadius:BorderRadius.circular(10)
                  
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<Datatag>(
                                     style: GoogleFonts.poppins(fontSize: 12,color: Colors.black),
                                          isExpanded: true,
                                          hint: Text("SELECT Tag"),
                                          value: selectedTag,
                                          items:taglist.map((tag){
                                            return DropdownMenuItem<Datatag>(
                                              value: tag,
                                              child: Text(tag.tagname.toString()),
                                            );
                                          }).toList() ,
                                          onChanged: (Datatag? value){
                                            setState(() {
                                              selectedTag = value;
                                            });
                                          }),
                                    ),
                                  )
                  
                                ],
                              ),
                            ),
                          ),
      
                          SizedBox(height: 10,),
                                  // name
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
                                            focusNode: namenode,
                                            controller: nameController,
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
                                            focusNode: desinationnode,
                                            controller: designationController,
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
                                            focusNode: phonenode,
                                            controller: phoneController,
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
                                            focusNode: emailnode,
                                            controller: emailController,
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
                                    maxline: 3,
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
                  
                          // SizedBox(height: 10),
                  
                  
                  SizedBox(height: 10,),
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
                ),
      
      
      
              ],
            ),
          ),
        ),
      
      ),
    );
  }
}
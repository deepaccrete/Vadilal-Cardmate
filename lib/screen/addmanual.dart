import 'dart:convert';
import 'dart:io';
import 'package:camera_app/api/GroupApi.dart';
import 'package:camera_app/api/TagApi.dart';
import 'package:camera_app/componets/snakbar.dart';
import 'package:camera_app/model/GroupModel.dart';
import 'package:camera_app/model/TagModel.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../local_package/country_state_city Picker/country_state_city_picker.dart';
import '../api/CardApi.dart';
import '../componets/button.dart';
import '../componets/textform.dart';
import '../constant/colors.dart';
import 'package:http/http.dart'as http ;
import 'bottomnav.dart';

class AddManual extends StatefulWidget {
  const AddManual({super.key});

  @override
  State<AddManual> createState() => _AddManualState();
}



class _AddManualState extends State<AddManual> {

  TextEditingController  nameController        = TextEditingController();
  TextEditingController  designationController = TextEditingController();
  TextEditingController  phoneController       = TextEditingController();
  TextEditingController  emailController       = TextEditingController();
  TextEditingController  companynameController = TextEditingController();
  TextEditingController  companyemailController       = TextEditingController();
  TextEditingController  addressController     = TextEditingController();
  TextEditingController  webController         = TextEditingController();
  TextEditingController  noteController        = TextEditingController();
  TextEditingController  companyWorkController         = TextEditingController();
  TextEditingController  pincodeController         = TextEditingController();

  TextEditingController country=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController city=TextEditingController();



  List<TextEditingController> personNameControllers = [];
  List<TextEditingController> personMobileControllers = [];
  List<TextEditingController> personEmailControllers = [];
  List<TextEditingController> personPositionControllers = [];

  FocusNode namenode = FocusNode();
  FocusNode designationnode = FocusNode();
  FocusNode phonenode = FocusNode();
  FocusNode emailnode = FocusNode();
  FocusNode companynamenode = FocusNode();
  FocusNode addressnode = FocusNode();
  FocusNode webnode = FocusNode();
  FocusNode notenode = FocusNode();
  FocusNode companyWorknode = FocusNode();
  FocusNode   pincodenode = FocusNode();

  List<Map<String, dynamic>> listdata = [];
  final ImagePicker _picker = ImagePicker();
  File? _selectFrontImage;
  // File? _selectBackImage;


  List<Datatag> taglist = [];
  List<Data> Groups = [];
  Datatag ? selectedTag;
  Data? selectedGroups;

  bool isGroupLoading = true;
  String? errormsg;
   bool istagLoading = true;


   final _formkey = GlobalKey<FormState>();


Future<void>FatchGroup ()async{
  try{
    GroupModel groupModel = await GroupApi.getGroup();
    if(groupModel.success == 1 && groupModel.data != null){
      setState(() {
        Groups = groupModel.data!;
        isGroupLoading = false;
      });
    }else{
      setState(() {
        errormsg = "no Groups Found";
        isGroupLoading = false;
      });    }
  }catch(e){
    setState(() {
      errormsg = "Something went wrong =>>>>>>>>>>> $e";
    });
  }
}


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
    FatchGroup();
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
    designationnode.dispose();
    phonenode.dispose();
    emailnode.dispose();
    companynamenode.dispose();
    addressnode.dispose();
    webnode.dispose();
    notenode.dispose();


    super.dispose();
  }

  Future<void>_pickerImage (ImageSource source)async{
    final  pickedFile = await _picker.pickImage(source: source);
    if(pickedFile != null){
      setState(() {
        _selectFrontImage = File(pickedFile.path);
      });
    }
  }




  void _showSnackBar(String message) {
    // Ensure the widget is still mounted before trying to show a SnackBar.
    // This prevents errors if the user navigates away rapidly.
    if (!mounted) return;

showCustomSnackbar(context, message);
  }

  // --- Data Upload Function ---
  Future<void> _uploadCardData() async {
    print('[_uploadCardData] Function started.');

    // 0. Pre-submission Validation
    if (!_formkey.currentState!.validate()) {
      _showSnackBar('Please fill all required text fields correctly.');
      print('[_uploadCardData] Form validation failed.');
      return; // Exit if form fields are invalid
    }
    if (_selectFrontImage == null) {
      _showSnackBar('Please select a front image.');
      print('[_uploadCardData] Front image not selected.');
      return; // Exit if front image is missing
    }
    // _selectBackImage is optional, so no mandatory check for it here.
    if (selectedTag == null) {
      _showSnackBar('Please select a business tag.');
      print('[_uploadCardData] Business tag not selected.');
      return; // Exit if tag is not selected
    }

    setState(() {
      // _isUploading = true;
    });
    print('[_uploadCardData] Validation passed. _isUploading set to true.');

    try {
      // 1. Prepare Person Details
      List<PersonDetails> persons = [];
      if (nameController.text.isNotEmpty ||
          phoneController.text.isNotEmpty ||
          emailController.text.isNotEmpty ||
          designationController.text.isNotEmpty) {
        persons.add(
          PersonDetails(
            name: nameController.text,
            phoneNumber: phoneController.text,
            email: emailController.text,
            position: designationController.text,
          ),
        );
      }

      // 2. Prepare DataCard text data (without image Base64 fields)
      DataCard cardTextData = DataCard(
        tagid: selectedTag!.tagid,
        groupid: selectedGroups!.groupid,
        companyName: companynameController.text,
        personDetails: persons.isNotEmpty ? persons : null,
        companyPhoneNumber: phoneController.text,
        companyAddress: addressController.text.isNotEmpty
            ? [addressController.text]
            : null,
        country: country.text,
          state: state.text,
        city: city.text,
        companyEmail: companyemailController.text,
        webAddress: webController.text,
        companySWorkDetails:companyWorkController.text,
        pincode: pincodeController.text,
        gSTIN: null
      );

      // 3. Convert DataCard to JSON string for the multipart field
      String jsonTextBody = json.encode(cardTextData.toJson());

      // --- DEBUGGING PRINT STATEMENT HERE ---
      print('[_uploadCardData] JSON Text Body to be sent:');
      print(jsonTextBody);
      // --- END DEBUGGING PRINT ---
      // 7. Send the request
      print('[_uploadCardData] Sending multipart request...');
      final http.Response response = await CardApi.addCardManually(frontImage:_selectFrontImage!, cardDetails:jsonTextBody);
      print('[_uploadCardData] Request sent. Status Code: ${response.statusCode}');

      // 8. Handle API response
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar('Card details uploaded successfully!');
        _clearForm();
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context)=> Bottomnav()));
      } else {
        String errorMsg = 'Failed to upload card. Status: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          try {
            final errorJson = json.decode(response.body);
            if (errorJson['message'] != null) {
              errorMsg = '${errorJson['message']} (Status: ${response.statusCode})';
            } else if (errorJson['error'] != null) {
              errorMsg = '${errorJson['error']} (Status: ${response.statusCode})';
            }
          } catch (e) {
            errorMsg += '\nRaw Response: ${response.body}';
          }
        }
        _showSnackBar(errorMsg);
        print('API Error: $errorMsg');
      }
    } catch (e) {
      _showSnackBar('An error occurred during upload: ${e.toString()}');
      print('Exception during upload: $e');
    } finally {
      setState(() {
        // _isUploading = false;
      });
      print('[_uploadCardData] Function finished. _isUploading set to false.');
    }
  }

  void _clearForm() {
    nameController.clear();
    designationController.clear();
    phoneController.clear();
    emailController.clear();
    companynameController.clear();
    companyemailController.clear();
    addressController.clear();
    webController.clear();
    noteController.clear();
    setState(() {
      _selectFrontImage = null;
      // _selectBackImage = null;
      selectedTag = null;
    });
    _formkey.currentState?.reset(); // Resets form validation state
  }


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
                    child: InkWell(
                        onTap: (){
                      _pickerImage(ImageSource.gallery);},
                      child: Container(
                        // alignment: Alignment.center,
                        height: height * 0.2,
                        width: width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,

                        ),
                        child: _selectFrontImage != null
                            ?ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.file(
                                                      _selectFrontImage!,
                                                      fit: BoxFit.cover,
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                    ),
                            )      :
                        Icon(Icons.image, color: Colors.grey),
                      ),
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
                                    'Select Group',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  Groups.isEmpty?
                                      Shimmer.fromColors(child: buildShimmer(context),
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade200)

                                  :Container(
                                    padding:EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(width:2,color:Colors.grey.shade200),
                                      color: Colors.white,
                                      borderRadius:BorderRadius.circular(10)
                  
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child:   Groups.isEmpty?
                                      Center(child: CircularProgressIndicator(color: primarycolor,)):
                                      DropdownButton<Data>(
                                     style: GoogleFonts.poppins(fontSize: 12,color: Colors.black),
                                          isExpanded: true,
                                          hint: Text("Select Group",style:GoogleFonts.poppins(),),
                                          value: selectedGroups,
                                          items:Groups.map((group){
                                            return DropdownMenuItem<Data>(
                                              value: group,
                                              child: Text(group.groupname.toString()),
                                            );
                                          }).toList() ,
                                          onChanged: (Data? value){
                                            setState(() {
                                              selectedGroups = value;
                                            });
                                          }),
                                    ),
                                  )
                  
                                ],
                              ),
                            ),
                          ),
      
                          SizedBox(height: 10,),

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
                                      Shimmer.fromColors(child: buildShimmer(context),
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade200)

                                  :Container(
                                    padding:EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(width:2,color:Colors.grey.shade200),
                                      color: Colors.white,
                                      borderRadius:BorderRadius.circular(10)

                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child:  taglist.isEmpty?
                                      Center(child: CircularProgressIndicator(color: primarycolor,)):
                                      DropdownButton<Datatag>(
                                     style: GoogleFonts.poppins(fontSize: 12,color: Colors.black),
                                          isExpanded: true,
                                          hint: Text("Select Tag",style:GoogleFonts.poppins(),),
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
                                            focusNode: namenode,
                                            controller: nameController,
                                            fillColor: Colors.white,
                                            labelColor: Colors.black54,
                                            contentpadding: 10,
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
                                              FocusScope.of(context).requestFocus(designationnode);
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
                                            focusNode: designationnode,
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
                                              FocusScope.of(context).requestFocus(phonenode);
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
                                              FocusScope.of(context).requestFocus(emailnode);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
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





                    //Country
                    SizedBox(height: 6),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          // color: Color(0xFFFEF7FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Country',
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            CountryStateCityPicker(
                              country: country,
                              state: state,
                              city: city,
                              isShowCountry: true,
                              dialogColor: Colors.grey.shade200,
                              textFieldDecoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: const Icon(Icons.arrow_downward_rounded),
                                border:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black26
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )],
                        ),
                      ),
                    ),
                    //State
                    SizedBox(height: 6),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          // color: Color(0xFFFEF7FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'State',
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            CountryStateCityPicker(
                              country: country,
                              state: state,
                              city: city,
                              isShowCountry: false,
                              isShowState:true,
                              isShowCity: false,
                              dialogColor: Colors.grey.shade200,
                              textFieldDecoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              suffixIcon: const Icon(Icons.arrow_downward_rounded),
                              border:OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black26
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //City
                    SizedBox(height: 6),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          // color: Color(0xFFFEF7FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City',
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            CountryStateCityPicker(
                              country: country,
                              state: state,
                              city: city,
                              isShowCountry: false,
                              isShowState:false,
                              isShowCity: true,
                              dialogColor: Colors.grey.shade200,
                              textFieldDecoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: const Icon(Icons.arrow_downward_rounded),
                                border:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  // Company pincode
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
                                    'PinCode',
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
                                    focusNode: pincodenode,
                                    controller: pincodeController,
                                    labeltext: 'Enter Pincode',
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

                          Card(
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),),
                            child: Container(
                              padding: EdgeInsets.all(20),

                              decoration: BoxDecoration(
                                // color: Color(0xFFFEF7FF),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Company Work Details',
                                    style: GoogleFonts.raleway(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CommonTextForm(
                                    maxline: 2,
                                    fillColor: Colors.white,
                                    labelColor: Colors.black54,
                                    contentpadding: 10,
                                    focusNode: companyWorknode,
                                    controller: companyWorkController,
                                    labeltext: "Enter Company's Work Details",
                                    borderc: 10,
                                    BorderColor: Colors.black26,
                                    icon: Icon(Icons.web, color: Colors.black54),
                                    obsecureText: false,

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
                            onTap: _uploadCardData,
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

  Widget buildShimmer(BuildContext context){
    return Container(
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
    );
  }
}
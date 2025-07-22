import 'package:camera_app/api/CardApi.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../api/GroupApi.dart';
import '../../api/TagApi.dart';
import '../../componets/button.dart';
import '../../componets/textform.dart';
import '../../constant/colors.dart';
import '../../local_package/country_state_city Picker/country_state_city_picker.dart';
import '../../model/GroupModel.dart';
import '../../model/TagModel.dart';
import '../../model/cardModel.dart';

class NewEditCard extends StatefulWidget {
  DataCard? dataCard;
  NewEditCard({super.key , this.dataCard});

  @override
  State<NewEditCard> createState() => _EditCardState();
}

class _EditCardState extends State<NewEditCard> {

  List<Datatag> taglist = [];
  Datatag ? selectedTag;

  // List<Grou>
  List<Data> Groups = [];
  Data? selectedGroups;

  bool isGroupLoading = true;
  String? errormsg;
  bool istagLoading = true;

  // Controllers for company details
  TextEditingController  companyEmailController       = TextEditingController();
  TextEditingController  companynameController = TextEditingController();
  TextEditingController  companyAddressController     = TextEditingController();
  TextEditingController  companyWebController         = TextEditingController();
  TextEditingController  companyPhoneController         = TextEditingController();
  TextEditingController  companyNoteController        = TextEditingController();

  TextEditingController country=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController city=TextEditingController();

  // Controllers for dynamic person details
  List<TextEditingController> personNameControllers = [];
  List<TextEditingController> personMobileControllers = [];
  List<TextEditingController> personEmailControllers = [];
  List<TextEditingController> personPositionControllers = [];


  FocusNode companynamenode = FocusNode();
  FocusNode companyphonenode = FocusNode();
  FocusNode companyemailnode = FocusNode();
  FocusNode companyAddressnode = FocusNode();
  FocusNode companyWebnode = FocusNode();
  FocusNode companyNotenode = FocusNode();

  // Focus Nodes for dynamic person details
  List<FocusNode> personnameNode = [];
  List<FocusNode> personMobileNode = [];
  List<FocusNode> personEmailNode = [];
  List<FocusNode> personPositionNode = [];

  List<PersonDetails> finalpersonDetails = [];



  // List<Map<String, dynamic>> listdata = [];

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose()
  {
    // Single controllers
    // nameController.dispose();
    // designationController.dispose();
    // phoneController.dispose();
    // emailController.dispose();
    companyEmailController.dispose();
    companynameController.dispose();
    companyAddressController.dispose();
    companyWebController.dispose();
    companyNoteController.dispose();
    companyPhoneController.dispose();

    // Focus nodes
    // namenode.dispose();
    // desinationnode.dispose();
    // phonenode.dispose();
    // emailnode.dispose();
    companynamenode.dispose();
    companyAddressnode.dispose();
    companyWebnode.dispose();
    companyNotenode.dispose();
    companyphonenode.dispose();

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

  void _gotohome() {
    // Use pushAndRemoveUntil to clear the navigation stack when going home
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Bottomnav()),
          (Route<dynamic> route) => false,
    );
  }
  @override
  void initState() {
    FetchTag();
    FatchGroup();
    super.initState();
    for (var person in widget.dataCard?.personDetails ?? []) {
      personNameControllers.add(TextEditingController(text:
      (person.name== null || person.name!.trim().isEmpty || person.name!.toLowerCase()=='null')
          ? ''
      :person!.name));
      personMobileControllers.add(TextEditingController(text:
      (person.phoneNumber== null || person.phoneNumber!.trim().isEmpty || person.phoneNumber!.toLowerCase()=='null')?
          '':
          person.phoneNumber!,
      ));
      personEmailControllers.add(TextEditingController(text:
      (person.email== null || person.email!.trim().isEmpty || person.email!.toLowerCase()=='null')
          ?''
              :person!.email));
      personPositionControllers.add(TextEditingController(text:

      (person.position== null || person.position!.trim().isEmpty || person.position!.toLowerCase()=='null')
          ?''
              :person!.position));

      personnameNode.add(FocusNode());
      personEmailNode.add(FocusNode());
      personMobileNode.add(FocusNode());
      personPositionNode.add(FocusNode());

    }
    if(personNameControllers.isEmpty){
      addemptyPerson();

    }
    companynameController = TextEditingController(text: widget.dataCard!.companyName);
    companyEmailController = TextEditingController(text: widget.dataCard!.companyEmail);
    companyAddressController = TextEditingController(
      text: widget.dataCard!.companyAddress?.join(', ') ?? '',
      // nameController = TextEditingController(text: widget.dataCard.personDetails)
    );
    companyPhoneController = TextEditingController(text: widget.dataCard!.companyPhoneNumber);
    if (widget.dataCard?.webAddress != null &&
        widget.dataCard!.webAddress!.trim().isNotEmpty &&
        widget.dataCard!.webAddress!.toLowerCase() != 'null') {
      companyWebController = TextEditingController(text: widget.dataCard!.webAddress);
    } else {
      companyWebController = TextEditingController(); // empty controller if invalid
    }
    if(widget.dataCard!.country!=null && widget.dataCard!.country!=''){
      country.text=widget.dataCard!.country!;
    }
    if(widget.dataCard!.state!=null && widget.dataCard!.state!=''){
      state.text=widget.dataCard!.state!;
    }
    if(widget.dataCard!.city!=null && widget.dataCard!.city!=''){
      city.text=widget.dataCard!.city!;
    }
  }

  void addemptyPerson(){
 setState(() {
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
 });
  }

  void removePerson(int index) {
    if (index < personNameControllers.length && personNameControllers.length > 1) {
      personNameControllers[index].dispose();
      personEmailControllers[index].dispose();
      personMobileControllers[index].dispose();
      personPositionControllers[index].dispose();

      personnameNode[index].dispose();
      personEmailNode[index].dispose();
      personMobileNode[index].dispose();
      personPositionNode[index].dispose();

      personNameControllers.removeAt(index);
      personEmailControllers.removeAt(index);
      personMobileControllers.removeAt(index);
      personPositionControllers.removeAt(index);



      personnameNode.removeAt(index);
      personEmailNode.removeAt(index);
      personMobileNode.removeAt(index);
      personPositionNode.removeAt(index);

/*
      namenode.
      desinationnode
      phonenode
      emailnode
      companynamenode
      addressnode
      webnode
      notenode
*/

      print('Removed person at index $index');
    }
  }

  Future<void>FatchGroup ()async{
    try{
      GroupModel groupModel = await GroupApi.getGroup();
      if(groupModel.success == 1 && groupModel.data != null){
        setState(() {
          Groups = groupModel.data!;
          isGroupLoading = false;
          if(widget.dataCard!.groupid!=null){
            int indexOfSelectedGroup= Groups.indexWhere((element) =>element.groupid==widget.dataCard!.groupid);
            selectedGroups=Groups[indexOfSelectedGroup];
          }
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
          if(widget.dataCard!.tagid!=null){
            int indexOfSelectedTag= taglist.indexWhere((element) =>element.tagid==widget.dataCard!.tagid);
            selectedTag=taglist[indexOfSelectedTag];
          }
        });
      }else{
        setState(() {
          errormsg = 'Api Not Working';
          istagLoading = false;
        });
      }
   ; }catch(e){
      print('something Went Wrong => $e');

    }finally{
      setState(() {
        istagLoading = false;
      });
    }
  }

  Future<void> _SaveCard()async{
    if(_formkey.currentState!.validate()){
      finalpersonDetails.clear();
     for(int i = 0; i< personNameControllers.length; i++){
       if(personNameControllers[i].text.trim().isNotEmpty){
         int? existingPersonId = (i< (widget.dataCard?.personDetails?.length ?? 0))
         ?widget.dataCard!.personDetails![i].cardpersonsid
         :null;


         finalpersonDetails.add(PersonDetails(
           cardpersonsid: existingPersonId, // Pass the existing ID or null for new
           name: personNameControllers[i].text.trim(),
           phoneNumber: personMobileControllers[i].text.trim(),
           email: personEmailControllers[i].text.trim(),
           position: personPositionControllers[i].text.trim(),
         )
         );
         
       }
     }

     if(selectedGroups == null){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please select a Group.')),
       );
       return;
     }
      if (selectedTag == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a Tag.')),
        );
        return;
      }



     final DataCard cardtosave = DataCard(

       cardID: widget.dataCard!.cardID,
         tagid: selectedTag!.tagid,
         groupid: selectedGroups!.groupid,
         companyName: companynameController.text.trim(),
         personDetails: finalpersonDetails,
        country: country.text,
       state: state.text,
       city: city.text,
       companyPhoneNumber:companyPhoneController.text.trim(),
       companyAddress: companyAddressController.text.trim().split(',').map((s)=> s.trim()).toList(),
       companyEmail:companyEmailController.text.trim(),
         webAddress: companyWebController.text.trim(),
     );


     // Map<String, dynamic> cardjson =  cardtosave.toJson();
    //
    //  String prettyjson = JsonEncoder.withIndent('').convert(cardjson);
    //
    //  debugPrint("=================================================");
    //  debugPrint("  Generated Card JSON (for debugging):          ");
    //  debugPrint("=================================================");
    //  debugPrint(prettyjson);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Card data collected and printed to console!')),
    //   );
    // }else{
    //   print('Error on save Details');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please correct the errors in the form.')),
    //   );
    //
    // }


    bool success = false;

    try{
      if(widget.dataCard!= null && widget.dataCard!.cardID != null){

        debugPrint("Attemept To Change Card ${widget.dataCard!.cardID}");

        success = await CardApi.updateCard(cardtosave);
        if(success){
          print('Card Updated Successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Card Updated')));
        _gotohome();
        }else{
          print('Card Updated Faild');

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save card. Please try again.')));

        }
      }

    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving card: $e')),
      );
      debugPrint('API Error: $e');

    }


}}

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
        title: Text('Edit Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //text card

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Text(
              //     'Card Front',
              //     textAlign: TextAlign.start,
              //     style: GoogleFonts.raleway(
              //       fontWeight: FontWeight.w700,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),

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
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  'Card Details',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 20,
                          color: Colors.indigo[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Company Details',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.only(left: 0,right: 0,bottom: 20),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                // padding: EdgeInsets.all(5),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Name Card
                      Card(
                        // margin: const EdgeInsets.only(bottom: 12.0),
                        // elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xFFFEF7FF),
                            borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                                Container(
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


                              SizedBox(height: 10,),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),

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


                              SizedBox(height: 10,),


                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 15),

                               decoration: BoxDecoration(
                                 // color: Color(0xFFFEF7FF),
                                 borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name',
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
                                            FocusScope.of(context).requestFocus(companyAddressnode);
                                          },
                                        )
                                      ],
                                    ),
                                  ),


                          
                              SizedBox(height: 6),
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 15),

                               decoration: BoxDecoration(
                                 // color: Color(0xFFFEF7FF),
                                 borderRadius: BorderRadius.circular(10)),
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
                                          focusNode: companyphonenode,
                                          controller: companyPhoneController,
                                          labeltext: 'Enter company Number',
                                          borderc: 10,
                                          BorderColor: Colors.black26,
                                          icon: Icon(Icons.maps_home_work_outlined, color: Colors.black54),
                                          obsecureText: false,
                                          // validator: (value) {
                                          //   if (value == null || value.isEmpty) {
                                          //     return "Please enter company name";
                                          //   }
                                          //   return null;
                                          // },
                                          onfieldsumbitted: (value) {
                                            FocusScope.of(context).requestFocus(companyAddressnode);
                                          },
                                        )
                                      ],
                                    ),
                                  ),



                              SizedBox(height: 6),
                            Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFFFEF7FF),
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
                                        focusNode: companyAddressnode,
                                        controller: companyAddressController,
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
                                          FocusScope.of(context).requestFocus(companyWebnode);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              //Country
                              SizedBox(height: 6),
                            Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                                              suffixIcon: const Icon(Icons.arrow_downward_rounded),
                                              border: const OutlineInputBorder(borderSide: BorderSide.none))
                                      ),
                                    ],
                                  ),
                                ),
                              //State
                              SizedBox(height: 6),
                            Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                                              suffixIcon: const Icon(Icons.arrow_downward_rounded),
                                              border: const OutlineInputBorder(borderSide: BorderSide.none))
                                      ),
                                    ],
                                  ),
                                ),
                              //City
                              SizedBox(height: 6),
                            Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                                              suffixIcon: const Icon(Icons.arrow_downward_rounded),
                                              border: const OutlineInputBorder(borderSide: BorderSide.none))
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 6),
                              // Company Website Card
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFFFEF7FF),
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
                                        focusNode: companyWebnode,
                                        controller: companyWebController,
                                        labeltext: 'Enter website',
                                        borderc: 10,
                                        BorderColor: Colors.black26,
                                        icon: Icon(Icons.web, color: Colors.black54),
                                        obsecureText: false,
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return "Please enter website";
                                        //   }
                                        //   return null;
                                        // },
                                        onfieldsumbitted: (value) {
                                          FocusScope.of(context).requestFocus(companyNotenode);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                          
                              SizedBox(height: 6),
                              // Note Card
                             Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFFFEF7FF),
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
                                        focusNode: companyNotenode,
                                        controller: companyNoteController,
                                        maxline: 5,
                                        labeltext: 'Enter note',
                                        borderc: 10,
                                        BorderColor: Colors.black26,
                                        icon: Icon(Icons.note_alt_outlined, color: Colors.black54),
                                        obsecureText: false,
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return "Please enter note";
                                        //   }
                                        //   return null;
                                        // },
                                      )
                                    ],
                                  ),
                                ),
                          
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 15,),
                      // people
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 20,
                                  color: Colors.blue[700],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'People',
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${personNameControllers.length} contacts',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 6),
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
                                      child:Icon(Icons.add),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      ...List.generate(
                        // personNameControllers.isEmpty? 1 : personNameControllers.length,
                          personNameControllers.length,
                              (index){
                            return  Card(
                              margin: EdgeInsets.all(10),
                              // margin: const EdgeInsets.only(bottom: 12.0),
                              // elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFEF7FF),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Person ${index +1}',style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),),
                                        SizedBox(width: 5,),
                                        InkWell(
                                          onTap: (){
                                            setState(() {

                                              removePerson(index);

                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Person Removed')));

                                            });
                                          },
                                          child: Icon(Icons.close,color: Colors.red,size: 30,),
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
                                    SizedBox(height: 6),

                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
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
                                                FocusScope.of(context).requestFocus(personPositionNode[index]);
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    SizedBox(height: 6),
                                   Container(
                                     padding: EdgeInsets.symmetric(horizontal: 15),
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
                                                FocusScope.of(context).requestFocus(personMobileNode[index]);
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    SizedBox(height: 6),
                                    // Phone Number Card

                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
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
                                                FocusScope.of(context).requestFocus(personEmailNode[index]);
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    SizedBox(height: 6),
                                    // Email Card

                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
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
                                           /*   validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "Please enter email";
                                                }
                                                return null;
                                              },*/
                                              onfieldsumbitted: (value) {
                                                FocusScope.of(context).unfocus();
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    SizedBox(height: 6),

                                  ],
                                ),
                              ),
                            );
                          }),

                      SizedBox(height: 20),
                      CommonButton(
                        height: height * 0.06,
                        bordercircular: 20,
                        onTap: (){
                          _SaveCard();

                          // widget.dataCard!.companyName=companynameController.text;
                          // print("------------------->>>>>>>>>>>${widget.dataCard!.toJson()}");
                          // // Navigator.push(context,MaterialPageRoute(builder: (context)=> Bottomnav()));
                          // // if(_formkey.currentState!.validate()){
                          // //   _addcardtoHive();
                          // // }
                          // // _addcardtoHive();
                          // // _addData();
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


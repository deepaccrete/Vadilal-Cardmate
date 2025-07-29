
import 'dart:typed_data';
import 'package:camera_app/api/CardApi.dart';
import 'package:camera_app/componets/snakbar.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screen/tempscreen/newEditScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../api/GroupApi.dart';
import '../api/TagApi.dart';
import '../model/GroupModel.dart';
import '../model/TagModel.dart';
import '../util/decordimage.dart';
import 'bottomnav.dart';
import 'fullScreenImageViewer.dart';

class DetailsScreen extends StatefulWidget {
  // final CardDetails cardDetails;
  DataCard dataCard;
  bool newEntry;

  // final int index;
  DetailsScreen({super.key, required this.dataCard,this.newEntry=false});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

// List<CardDetails> _cards = [];

Future<void> callNumber(String number) async {
  try {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could Not Luanch $number');
    }
  } catch (e) {
    print('Error on CallNumber $e');
  }
}

Future<void> sendmail({required String toEmail, String subject = '', String body = ''}) async {
  try {
    final Uri emailUri = Uri(scheme: 'mailto', path: toEmail, queryParameters: {'subject': subject, 'body': body});

    print("Generated Mail URL: $emailUri");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could Not Launch $emailUri');
    }
  } catch (e) {
    print('Send Mail Error $e');
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  // New entry fields
  TextEditingController noteController = TextEditingController();

  //
  List<Datatag> taglist = [];
  List<Data> Groups = [];

  Datatag ? selectedTag;
  Data? selectedGroups;

  @override
  void initState() {
    super.initState();
    // _decodeCardImages();
    _imagetoList();
    if (widget.newEntry) {
      // Initialize your tag and group lists here
      _loadTagsAndGroups();
    }
  }

  // Add this method to load your tags and groups
  void _loadTagsAndGroups() {
    if(widget.newEntry){
      FetchTag();
      FetchGroup();
    }
  }

  bool get hasInputData {
    return noteController.text.isNotEmpty ||
        selectedTag != null ||
        selectedGroups != null;
  }

  Future<void> _updateCard() async {
    // TODO: Implement your update logic here
    print('Updating card with:');
    print('Note: ${noteController.text}');
    print('Selected Tag: ${selectedTag?.tagname}');
    print('Selected Group: ${selectedGroups?.groupname}');
    await CardApi.updateCardTagGroupNote(widget.dataCard.cardID, noteController.text, selectedTag?.tagid, selectedGroups?.groupid).then((value) {
      print("--------------> ${value}");
      if(value){
        Bottomnav().launch(context,isNewTask:true);
      }else{
        showCustomSnackbar(context, 'Error Updating');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Updating')));
      }
    },);
    // After successful update, you might want to navigate back
    // Navigator.pop(context, true);t

  }

  Future<void>FetchGroup ()async{
    try{
      GroupModel groupModel = await GroupApi.getGroup();
      if(groupModel.success == 1 && groupModel.data != null){
        setState(() {
          Groups = groupModel.data!;
          if(widget.dataCard.groupid !=null){
            int indexOfSelectedGroup= Groups.indexWhere((element) =>element.groupid==widget.dataCard.groupid);
            selectedGroups=Groups[indexOfSelectedGroup];
          }
        });
      }else{   }
    }catch(e){
      setState(() {
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
          if(widget.dataCard.tagid!=null){
            int indexOfSelectedTag= taglist.indexWhere((element) =>element.tagid==widget.dataCard.tagid);
            selectedTag=taglist[indexOfSelectedTag];
          }
        });
      }else{
      }
      ; }catch(e){
      print('something Went Wrong => $e');

    }finally{
      setState(() {
      });
    }
  }

  void _cancelUpdate() {
    setState(() {
      noteController.clear();
      selectedTag = null;
      selectedGroups = null;
    });
    Navigator.pop(context);
  }

  //Hive Load Card
  /*Future<void> _loadCard() async {
    final box = await Hive.openBox<CardDetails>('cardbox');
    setState(() {
      _cards = box.values.toList();
    });
  }*/

  //   Delete Card
  /*
  void _deleteCardhive(dynamic id) async {
    await HiveBoxes.deleteCard(id);
  }
*/

  Future<void> RequestPermission() async {
    if (await Permission.contacts.isGranted) {
      print('Contacts permission already granted');
      return;
    }

    PermissionStatus status = await Permission.contacts.request();

    if (status.isGranted) {
      print('Contacts permission granted');
    } else if (status.isDenied) {
      print('Contacts permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // guide user to manually enable permission
    }
  }

  Future<void> SaveContact({required String firstname, String? lastName, String? phone, String? email}) async {
    await RequestPermission();

    // Handle multiple phone numbers
    List<Item> phoneItems = [];
    if (phone != null && phone.isNotEmpty) {
      final phoneList = phone.split(',').map((p) => p.trim()).toList();
      phoneItems = phoneList.map((number) => Item(label: "mobile", value: number)).toList();
    }

    // Handle email
    List<Item> emailItems = [];
    if (email != null && email.isNotEmpty) {
      emailItems = [Item(label: "work", value: email)];
    }

    final newContact = Contact(givenName: firstname, familyName: lastName, phones: phoneItems, emails: emailItems);

    await ContactsService.addContact(newContact);
    print('Contact Saved: $newContact');
  }

  // This function will generate and share ALL card details
  void _shareAllCardDetails() async {
    // 1. Get the formatted string from your DataCard object
    final String textToShare = widget.dataCard.toShareString();

    // 2. Optional: Add a check to ensure there's meaningful content to share
    // This checks if the string is empty or only contains the header/footer
    if (textToShare.trim().length <=
        ('--- Business Card Details ---' + '\n' + '\n' + '--- End of Details ---').length) {


      showCustomSnackbar(context, 'No details found to share for this card.');
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('No details found to share for this card.')));
      return;
    }

    try {
      // 3. Get the RenderBox for iPad popover (important for tablets)
      final RenderBox? box = context.findRenderObject() as RenderBox?;

      // 4. Use share_plus to open the native share sheet
      await SharePlus.instance.share(
        ShareParams(
          text: textToShare,
          subject: 'Business Card Details: ${widget.dataCard.companyName}', // A descriptive subject
          // sharePositionOrigin is important for   to show a popover
          sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );
    } catch (e) {
      print('Error sharing card details: $e');
      showCustomSnackbar(context, 'Failed to share card details: $e');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to share card details: $e')));
    }
  }

  int _currentIndex = 0;


  //if decode image use this
  // List<Uint8List> images = [];

List<String> imagesurl = [];






void _imagetoList (){
  if(widget.dataCard.cardFrontImageBase64!= null &&
      widget.dataCard.cardFrontImageBase64!.isNotEmpty
  ){
    imagesurl.add(widget.dataCard.cardFrontImageBase64!);

  }
  if(widget.dataCard.cardBackImageBase64!= null &&
      widget.dataCard.cardBackImageBase64!.isNotEmpty
  ){
    imagesurl.add(widget.dataCard.cardBackImageBase64!);
  }

}

  // void _decodeCardImages() {
  //
  //
  //   if(widget.dataCard.isBase64==1){
  //     // A temporary list to hold the results.
  //     final List<Uint8List> decodedImages = [];
  //
  //     // List of all possible images to process.
  //     final base64Strings = [
  //       widget.dataCard.cardFrontImageBase64,
  //       widget.dataCard.cardBackImageBase64,
  //     ];
  //
  //     // Loop through the strings and decode them.
  //     for (final b64String in base64Strings) {
  //       // Use a single helper for null/empty checks
  //       if (b64String != null && b64String.isNotEmpty) {
  //         final imageBytes = decodeBase64Image(b64String);
  //         if (imageBytes != null) {
  //           decodedImages.add(imageBytes);
  //         }
  //       }
  //     }
  //
  //     // CRITICAL: Call setState to update the UI with the processed images.
  //     // The 'if (mounted)' check is a safety measure to prevent errors.
  //
  //
  //     if (mounted) {
  //       setState(() {
  //         images = decodedImages;
  //       });
  //     }
  //   }else{
  //     if(widget.dataCard.cardFrontImageBase64!= null &&
  //         widget.dataCard.cardFrontImageBase64!.isNotEmpty
  //     ){
  //       imagesurl.add(widget.dataCard.cardFrontImageBase64!);
  //
  //     }
  //     if(widget.dataCard.cardBackImageBase64!= null &&
  //         widget.dataCard.cardBackImageBase64!.isNotEmpty
  //     ){
  //       imagesurl.add(widget.dataCard.cardBackImageBase64!);
  //     }
  //
  //   }
  //
  // }
  @override

  Widget build(BuildContext context) {

    // final width = MediaQuery.of(context).size.width * 1;
    // final height = MediaQuery.of(context).size.height * 1;

    // Uint8List? decodeBase64Image(String base64String) {
    //   try {
    //     print('Attempting to decode base64 string...');
    //
    //     if (base64String.isEmpty) {
    //       print('Error: base64 string is empty');
    //       return null;
    //     }
    //
    //     // Print the first part of the string to see what format we're dealing with
    //     print('Original string starts with: ${base64String.substring(0, min(50, base64String.length))}');
    //
    //     String cleanBase64 = base64String;
    //
    //     // If the string starts with 'data:', extract the base64 part
    //     if (cleanBase64.startsWith('data:')) {
    //       int commaIndex = cleanBase64.indexOf(',');
    //       if (commaIndex != -1) {
    //         cleanBase64 = cleanBase64.substring(commaIndex + 1);
    //         print('Removed data: prefix directly from string');
    //       }
    //     }
    //
    //     // Remove any whitespace
    //     cleanBase64 = cleanBase64.replaceAll(RegExp(r'[\s\n]'), '');
    //
    //     // Add padding if needed
    //     int paddingLength = cleanBase64.length % 4;
    //     if (paddingLength > 0) {
    //       cleanBase64 += '=' * (4 - paddingLength);
    //     }
    //
    //     try {
    //       // First decode attempt
    //       var bytes = base64Decode(cleanBase64);
    //       print('First decode successful, got ${bytes.length} bytes');
    //
    //       // Check if the result is another base64 string
    //       String decodedString = String.fromCharCodes(bytes);
    //       if (decodedString.contains('base64,')) {
    //         print('Found another base64 string, decoding again...');
    //         String secondBase64 = decodedString.split('base64,').last;
    //         // Clean up the second base64 string
    //         secondBase64 = secondBase64.replaceAll(RegExp(r'[\s\n]'), '');
    //         paddingLength = secondBase64.length % 4;
    //         if (paddingLength > 0) {
    //           secondBase64 += '=' * (4 - paddingLength);
    //         }
    //         bytes = base64Decode(secondBase64);
    //         print('Second decode successful, got ${bytes.length} bytes');
    //       }
    //
    //       // Verify this is actually an image by checking for common image headers
    //       if (bytes.length > 8) {
    //         // Check for JPEG header (FF D8)
    //         if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
    //           print('Detected JPEG image format');
    //           return bytes;
    //         }
    //         // Check for PNG header (89 50 4E 47)
    //         if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
    //           print('Detected PNG image format');
    //           return bytes;
    //         }
    //         // Check for GIF header (47 49 46)
    //         if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
    //           print('Detected GIF image format');
    //           return bytes;
    //         }
    //
    //         print(
    //           'Warning: No valid image header detected. First 8 bytes: [${bytes.take(8).map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}]',
    //         );
    //       }
    //
    //       return bytes;
    //     } catch (e) {
    //       print('Base64 decoding error: $e');
    //       return null;
    //     }
    //   } catch (e) {
    //     print('Error in decodeBase64Image: $e');
    //     return null;
    //   }
    // }
    //
    // print('\nProcessing front image...');
    // if (widget.dataCard.cardFrontImageBase64 != null && widget.dataCard.cardFrontImageBase64!.isNotEmpty) {
    //   final frontImage = decodeBase64Image(widget.dataCard.cardFrontImageBase64!);
    //   if (frontImage != null) {
    //     images.add(frontImage);
    //     print('Successfully added front image');
    //   } else {
    //     print('Failed to decode front image');
    //   }
    // } else {
    //   print('No front image data available');
    // }
    //
    // print('\nProcessing back image...');
    // if (widget.dataCard.cardBackImageBase64 != null && widget.dataCard.cardBackImageBase64!.isNotEmpty) {
    //   final backImage = decodeBase64Image(widget.dataCard.cardBackImageBase64!);
    //   if (backImage != null) {
    //     images.add(backImage);
    //     print('Successfully added back image');
    //   } else {
    //     print('Failed to decode back image');
    //   }
    // } else {
    //   print('No back image data available');
    // }
    //
    // print('\nFinal results:');
    // print('Total images decoded: ${images.length}');
    print(Theme.of(context).cardColor);
    final String? phoneNumbers = widget.dataCard.companyPhoneNumber;
    return Scaffold(

      backgroundColor: screenBGColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 1),
        elevation: 10,
        backgroundColor: screenBGColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title:  Text(
          // widget.dataCard.companyName.toString(),
          'Card Details',
          style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(


        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Existing card details section continues here...
              // Image Build
              _buildImage(),

            // DotIndicator(pageController: pageController, pages: items),

               // List imagesrc = widget.dataCard.isBase64 ? images :imagesurl
            if (imagesurl.isNotEmpty)
          Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DotsIndicator(
        dotsCount: imagesurl.length,
        position: _currentIndex.toDouble(),
        decorator: DotsDecorator(
          color: Colors.grey,
          activeColor: Colors.blueAccent,
          size: Size.square(9.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          spacing: EdgeInsets.all(4.0),
        ),
      ),
    ),


              SizedBox(height: 20),

              // Only show action buttons if NOT in newEntry mode
              if (!widget.newEntry)
                _buildButtons(),

              SizedBox(height: 20),
              // Card Details And General



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Card Details', style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18)),

                  if(widget.dataCard.tag!=null && widget.dataCard.tag != '')
                    _buildSelectedItem(
                      widget.dataCard.tag!,
                      Icons.local_offer,
                      0,
                      true,
                    ),
                ],
              ),
              SizedBox(height: 10),

              // Company Section
              _buildCompanySection(),

              // People Section
              if (widget.dataCard.personDetails != null && widget.dataCard.personDetails!.isNotEmpty)
                _buildPeopleSection(),
              // New Entry Section - Show when newEntry is true
              if (widget.newEntry) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Details',
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Note TextField
                        TextFormField(
                          controller: noteController,
                          decoration: InputDecoration(
                            labelText: 'Enter Note',
                            hintText: 'Add a note for this card...',
                            labelStyle: GoogleFonts.poppins(fontSize: 14),
                            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            prefixIcon: Icon(Icons.note_add, color: Colors.grey[600]),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {}); // Refresh to show/hide update button
                          },
                        ),
                        SizedBox(height: 16),

                        // Tag Dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.local_offer, color: Colors.grey[600], size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: taglist.isEmpty
                                      ? Center(child: CircularProgressIndicator(color: primarycolor))
                                      : DropdownButton<Datatag>(
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
                                    isExpanded: true,
                                    hint: Text("Select Tag", style: GoogleFonts.poppins()),
                                    value: selectedTag,
                                    items: taglist.map((tag) {
                                      return DropdownMenuItem<Datatag>(
                                        value: tag,
                                        child: Text(tag.tagname.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (Datatag? value) {
                                      setState(() {
                                        selectedTag = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Group Dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.group, color: Colors.grey[600], size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: Groups.isEmpty
                                      ? Center(child: CircularProgressIndicator(color: primarycolor))
                                      : DropdownButton<Data>(
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
                                    isExpanded: true,
                                    hint: Text("Select Group", style: GoogleFonts.poppins()),
                                    value: selectedGroups,
                                    items: Groups.map((group) {
                                      return DropdownMenuItem<Data>(
                                        value: group,
                                        child: Text(group.groupname.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (Data? value) {
                                      setState(() {
                                        selectedGroups = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Update and Cancel Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelUpdate,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: hasInputData ? _updateCard : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hasInputData ? Colors.blue : Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  elevation: hasInputData ? 2 : 0,
                                ),
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.poppins(
                                    color: hasInputData ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
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
                SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildImage (){
    final bool isBase64 = widget.dataCard.isBase64 == 1;
    // Determine the correct data source list.
    // final List<dynamic> imageSource = isBase64 ? images : imagesurl;

    if (imagesurl.isEmpty) {
      return const Center(child: Icon(Icons.image, color: Colors.grey, size: 50));
    }

   return  Center(
      child: Container(
        alignment: Alignment.center,
        child:
            // widget.dataCard.isBase64 == 1?
        //    ( images.isNotEmpty ?
        //    CarouselSlider(
        //   carouselController: CarouselSliderController(),
        //   options: CarouselOptions(
        //     onPageChanged: (index, reason) {
        //       setState(() {
        //         _currentIndex = index;
        //       });
        //     },
        //     enlargeCenterPage: true,
        //     enableInfiniteScroll: false,
        //     autoPlay: false,
        //     viewportFraction: 0.9,
        //   ),
        //   items:
        //   images.map((imgBytes) {
        //     return Builder(
        //       builder: (BuildContext context) {
        //         return GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               PageRouteBuilder(
        //                 pageBuilder: (context, animation, secondaryAnimation) =>
        //                     FullScreenImageViewer(
        //                       images: images,
        //                       initialIndex: _currentIndex,
        //                     ),
        //                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //                   return FadeTransition(
        //                     opacity: animation,
        //                     child: child,
        //                   );
        //                 },
        //                 transitionDuration: const Duration(milliseconds: 300),
        //               ),
        //             );
        //           },
        //           child: Container(
        //             width: MediaQuery.of(context).size.width,
        //             margin: EdgeInsets.symmetric(horizontal: 5.0),
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.circular(10),
        //               child: InteractiveViewer(
        //                 minScale: 0.5,
        //                 maxScale: 5.0,
        //                 child: Image.memory(imgBytes, fit: BoxFit.contain),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   }).toList(),
        // )
        //     : Icon(Icons.image, color: Colors.grey))
        //    :imagesurl.isNotEmpty?
           CarouselSlider(
              carouselController: CarouselSliderController(),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 0.9,
              ),
              items:
              imagesurl.map((imgBytes) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                FullScreenImageViewer(
                                  // isbase64: widget.dataCard.isBase64==1,
                                  images: imagesurl,
                                  initialIndex: _currentIndex,
                                ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 5.0,
                            child:

                              // if want use decode use this

                            // isBase64?
                            // Image.memory(imgBytes, fit: BoxFit.contain):
                              Image.network(imgBytes ?? '', fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
                // : Icon(Icons.image, color: Colors.grey)
      ),
    );
  }

  Widget _buildButtons(){
    final width = MediaQuery.of(context).size.width * 1;
    // final height = MediaQuery.of(context).size.height * 1;
  return  Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add button
          if (appStore.appSetting!.isadd ?? false)InkWell(
            onTap: () async {
              try {
                await SaveContact(
                  firstname: widget.dataCard.companyName ?? '',
                  email: widget.dataCard.companyEmail ?? '',
                  phone: widget.dataCard.companyPhoneNumber ?? '',
                );
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Contact Saved',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      content: Container(
                        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        child: Icon(Icons.check, color: Colors.white, size: 100),
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK', style: GoogleFonts.poppins(fontSize: 18)),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                print("Error during contact save: $e");
              }
            },

            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                  child: Icon(Icons.person_add_alt_outlined, color: Colors.green),
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
          ),
          // Share button
          if(appStore.appSetting!.isshare??false)InkWell(
            onTap: () {
              _shareAllCardDetails();
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
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
          ),
          // Edit button
          // if(appStore.appSetting!.isedit??false)
            InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewEditCard(dataCard: widget.dataCard)),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey.shade500, shape: BoxShape.circle),
                    child: Icon(Icons.edit_outlined, color: HexColor('#000000')),
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
          if(appStore.appSetting!.isdeletecard??false)InkWell(
            onTap: () async {
              showConfirmDialogCustom(
                context,
                title: "Are you sure you want to delete this card",
                dialogType: DialogType.DELETE,
                onAccept: (p0) async {
                  await CardApi.deleteCard(widget.dataCard.cardID).then(
                        (value) {
                      if(value['success']==1){
                        Bottomnav().launch(context,isNewTask: true);
                      }
                    },
                  );
                },
              );
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.red.shade100, shape: BoxShape.circle),
                  child: Icon(Icons.delete_outline, color: HexColor('903034')),
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
    );

  }

  Widget _buildCompanySection(){
   return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // business
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.business_outlined, size: 20, color: Colors.indigo[700]),
                    SizedBox(width: 8),
                    Text(
                      'Company Details',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                if(widget.dataCard.group!=null && widget.dataCard.group != '')
                  _buildSelectedItem(
                    widget.dataCard.group!,
                    Icons.group,
                    1,
                    false,
                  ),
              ],
            ),
          ),

          SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [


                ListTile(
                  onTap: () {
                    // Handle company email tap
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.business, color: Colors.blue[700], size: 20),
                  ),
                  title: Text(
                    'Company Name',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  subtitle: Text(
                    widget.dataCard.companyName!,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // (isNullable(widget.dataCard.companyEmail))
                //     ? SizedBox()
                //     :
                if(isnotnull(widget.dataCard.companyEmail))
                  ListTile(
                    onTap: () {
                      if (widget.dataCard.companyEmail == null) {
                        sendmail(toEmail: widget.dataCard.companyEmail.toString());
                      }
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.email_outlined, color: Colors.blue[700], size: 20),
                    ),
                    title: Text(
                      'Email',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.companyEmail!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),


                // if (widget.dataCard.companyPhoneNumber != null &&
                //     widget.dataCard.companyPhoneNumber!.isNotEmpty &&
                //     widget.dataCard.companyPhoneNumber!.toLowerCase() != 'null')

                if(isnotnull(widget.dataCard.companyPhoneNumber))
                  ...widget.dataCard.companyPhoneNumber!
                      .split(',')
                      .map(
                        (phone) => ListTile(
                      onTap: () {
                        callNumber(phone.toString());
                      },
                      onLongPress: () async {
                        await Clipboard.setData(ClipboardData(text: phone.trim()));
                        showCustomSnackbar(context, 'Copied To ClipBoard');
                        // ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.phone_outlined, color: Colors.green[700], size: 20),
                      ),
                      title: Text(
                        'Phone',
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        phone.trim(),
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      .toList(),



                // if (widget.dataCard.webAddress != null && widget.dataCard.webAddress!.isNotEmpty)
                if(isnotnull(widget.dataCard.webAddress))
                  ListTile(
                    onTap: () {
                      // if(widget.dataCard.companyEmail!= null&&
                      //     widget.dataCard.companyEmail!.isNotEmpty){
                      //   sendmail(toEmail: widget.dataCard.companyEmail
                      //       .toString());
                      // }
                      // if(widget.dataCard.companyEmail==null){
                      //   sendmail(toEmail: widget.dataCard.companyEmail
                      //       .toString());
                      // }
                      // Handle company email tap
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.business, color: Colors.blue[700], size: 20),
                    ),
                    title: Text(
                      'Web Address',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    subtitle: Text(
                      widget.dataCard.webAddress!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                if (widget.dataCard.companyAddress != null && widget.dataCard.companyAddress!.isNotEmpty && widget.dataCard.companyAddress! != "null")
                // if(isnotnull(widget.dataCard.companyAddress))
                  ListTile(
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.dataCard.companyAddress!.join(', ')),
                      );
                      showCustomSnackbar(context,'Copied To ClipBoard' );
                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on_outlined, color: Colors.orange[700], size: 20),
                    ),
                    title: Text(
                      'Address',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.companyAddress!.join(', '),
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                //Country
                // if (widget.dataCard.country != null && widget.dataCard.country!.isNotEmpty && widget.dataCard.country! != "null")
                if(isnotnull(widget.dataCard.country))
                  ListTile(
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.dataCard.companyAddress!.join(', ')),
                      );
                      showCustomSnackbar(context,'Copied To ClipBoard' );
                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on_outlined, color: Colors.orange[700], size: 20),
                    ),
                    title: Text(
                      'Country',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.country!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                //State
                // if (widget.dataCard.state != null && widget.dataCard.state!.isNotEmpty && widget.dataCard.state! != "null")
                if(isnotnull(widget.dataCard.state))
                  ListTile(
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.dataCard.companyAddress!.join(', ')),
                      );
                      showCustomSnackbar(context,'Copied To ClipBoard' );
                      //
                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on_outlined, color: Colors.orange[700], size: 20),
                    ),
                    title: Text(
                      'State',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.state??"",
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),


                //city
                // if (widget.dataCard.city != null && widget.dataCard.city!.isNotEmpty && widget.dataCard.city! != "null")
                if(isnotnull(widget.dataCard.city))
                  ListTile(
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.dataCard.companyAddress!.join(', ')),
                      );
                      showCustomSnackbar(context,'Copied To ClipBoard' );

                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on_outlined, color: Colors.orange[700], size: 20),
                    ),
                    title: Text(
                      'City',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.city??"",
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),




                if(isnotnull(widget.dataCard.pincode))
                  ListTile(
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.dataCard.companyAddress!.join(', ')),
                      );
                      showCustomSnackbar(context,'Copied To ClipBoard' );

                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_on_outlined, color: Colors.orange[500], size: 20),
                    ),
                    title: Text(
                      'Pincode',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.pincode??"",
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),




                // (widget.dataCard.companySWorkDetails == null ||
                //     widget.dataCard.companySWorkDetails!.trim().isEmpty ||
                //     widget.dataCard.companySWorkDetails!.toLowerCase() == 'null')
                //     ? SizedBox()
                //     :
                if(isnotnull(widget.dataCard.companySWorkDetails))
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.work_outline, color: Colors.purple[700], size: 20),
                    ),
                    title: Text(
                      'Company Work',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.companySWorkDetails!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // (widget.dataCard.note == null ||
                //     widget.dataCard.note!.trim().isEmpty ||
                //     widget.dataCard.note!.toLowerCase() == 'null')
                //     ? SizedBox():

                if(isnotnull(widget.dataCard.note))
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.note_alt_outlined, color: Colors.grey[700], size: 20),
                    ),
                    title: Text(
                      'Note',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.dataCard.note!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildPeopleSection(){
  return  Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 20, color: Colors.blue[700]),
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
                Text(
                  '${widget.dataCard.personDetails!.length} contacts',
                  style: GoogleFonts.raleway(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          ...widget.dataCard.personDetails!.map(
                (person) => Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    person.name?.isNotEmpty == true ? person.name![0].toUpperCase() : '?',
                                    style: GoogleFonts.raleway(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ),
                              ),
                              if (person.position != null)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[200]!, width: 2),
                                    ),
                                    child: Icon(Icons.work_outline, size: 12, color: Colors.blue[700]),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (person.name == null ||
                                    person.name!.trim().isEmpty ||
                                    person.name!.toLowerCase() == 'null')
                                    ? SizedBox()
                                    : Text(
                                  person.name!,
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                            onPressed: () {
                              // Show options menu
                            },
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            (person.position == null || person.position!.trim().isEmpty || person.position!.toLowerCase() == 'null')
                                ?SizedBox()
                                : ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.work, color: Colors.green[700], size: 18),
                              ),
                              title: Text(
                                person.position!,
                                style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[800]),
                              ),
                            ),

                            (person.phoneNumber == null ||
                                person.phoneNumber!.trim().isEmpty ||
                                person.phoneNumber!.toLowerCase() == 'null')
                                ? SizedBox()
                                :
                            ListTile(
                              onTap: () {
                                callNumber(person.phoneNumber.toString());
                              },
                              onLongPress: () async {
                                await Clipboard.setData(ClipboardData(text: person.phoneNumber!));
                                showCustomSnackbar(context,'Copied To ClipBoard' );

                                // ScaffoldMessenger.of(
                                //   context,
                                // ).showSnackBar(SnackBar(content: Text('Copied To ClipBoard')));
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.phone_outlined, color: Colors.green[700], size: 18),
                              ),
                              title: Text(
                                person.phoneNumber!,
                                style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[800]),
                              ),
                            ),

                            (person.email == null ||
                                person.email!.trim().isEmpty ||
                                person.email!.toLowerCase() == 'null')
                                ? SizedBox()
                                : ListTile(
                              onTap: () {
                                // Handle email tap
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.email_outlined, color: Colors.red[700], size: 18),
                              ),
                              title: Text(
                                person.email!,
                                style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[800]),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.open_in_new, color: Colors.grey[600], size: 20),
                                onPressed: () {
                                  sendmail(
                                    subject: '',
                                    body: '',
                                    toEmail: person.email!,
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
            ),
          ),
        ],
      ),
    );

  }
  Color _getDynamicColor(int index) {
    const List<Color> availableColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    return availableColors[index % availableColors.length];
  }

  Widget _buildSelectedItem(String name, IconData icon, int colorIndex, bool isTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getDynamicColor(colorIndex).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _getDynamicColor(colorIndex)),
          SizedBox(width: 6),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }




  // bool isNullable (String? text){
  //   return text == null || text!.trim().isEmpty || text!.toLowerCase() == 'null' ;
  // }

  bool isnotnull(String? text, ){
    return text != null && text!.isNotEmpty && text!.toLowerCase() != 'null';
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
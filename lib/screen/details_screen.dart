import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
// import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/screen/EditCard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';




class DetailsScreen extends StatefulWidget {

  // final CardDetails cardDetails;
  DataCard dataCard;

  // final int index;
  DetailsScreen({
    super.key,
    required this.dataCard,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

// List<CardDetails> _cards = [];

Future<void> callNumber(String number)async{
  try{
    final Uri phoneUri = Uri(scheme: 'tel',path: number);
    if( await canLaunchUrl(phoneUri)){
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    }else{
      throw Exception('Could Not Luanch $number');
    }
  }catch(e){
    print('Error on CallNumber $e');
  }

}

Future<void> sendmail({
  required String toEmail,
  String subject = '',
  String body = '',
}) async {
  try {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

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
Future<void> SaveContact({
  required String firstname,
  String? lastName,
  String? phone,
  String? email,
}) async {
  await RequestPermission();

  // Handle multiple phone numbers
  List<Item> phoneItems = [];
  if (phone != null && phone.isNotEmpty) {
    final phoneList = phone.split(',').map((p) => p.trim()).toList();
    phoneItems = phoneList.map(( number) => Item(label: "mobile", value: number)).toList();
  }

  // Handle email
  List<Item> emailItems = [];
  if (email != null && email.isNotEmpty) {
    emailItems = [Item(label: "work", value: email)];
  }

  final newContact = Contact(
    givenName: firstname,
    familyName: lastName,
    phones: phoneItems,
    emails: emailItems,
  );

  await ContactsService.addContact(newContact);
  print('Contact Saved: $newContact');
}


// This function will generate and share ALL card details
void _shareAllCardDetails() async {
  // 1. Get the formatted string from your DataCard object
  final String textToShare = widget.dataCard.toShareString();

  // 2. Optional: Add a check to ensure there's meaningful content to share
  // This checks if the string is empty or only contains the header/footer
  if (textToShare.trim().length <= ('--- Business Card Details ---' + '\n' + '\n' + '--- End of Details ---').length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No details found to share for this card.')),
    );
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
        // sharePositionOrigin is important for iPads to show a popover
        sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );
  } catch (e) {
    print('Error sharing card details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to share card details: $e')),
    );
  }
}

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    List<Uint8List> images = [];
    List<dynamic> imagesurl = [];
    Uint8List? decodeBase64Image(String base64String) {
      try {
        print('Attempting to decode base64 string...');

        if (base64String.isEmpty) {
          print('Error: base64 string is empty');
          return null;
        }

        // Print the first part of the string to see what format we're dealing with
        print(
          'Original string starts with: ${base64String.substring(0, min(50, base64String.length))}',
        );

        String cleanBase64 = base64String;

        // If the string starts with 'data:', extract the base64 part
        if (cleanBase64.startsWith('data:')) {
          int commaIndex = cleanBase64.indexOf(',');
          if (commaIndex != -1) {
            cleanBase64 = cleanBase64.substring(commaIndex + 1);
            print('Removed data: prefix directly from string');
          }
        }

        // Remove any whitespace
        cleanBase64 = cleanBase64.replaceAll(RegExp(r'[\s\n]'), '');

        // Add padding if needed
        int paddingLength = cleanBase64.length % 4;
        if (paddingLength > 0) {
          cleanBase64 += '=' * (4 - paddingLength);
        }

        try {
          // First decode attempt
          var bytes = base64Decode(cleanBase64);
          print('First decode successful, got ${bytes.length} bytes');

          // Check if the result is another base64 string
          String decodedString = String.fromCharCodes(bytes);
          if (decodedString.contains('base64,')) {
            print('Found another base64 string, decoding again...');
            String secondBase64 = decodedString.split('base64,').last;
            // Clean up the second base64 string
            secondBase64 = secondBase64.replaceAll(RegExp(r'[\s\n]'), '');
            paddingLength = secondBase64.length % 4;
            if (paddingLength > 0) {
              secondBase64 += '=' * (4 - paddingLength);
            }
            bytes = base64Decode(secondBase64);
            print('Second decode successful, got ${bytes.length} bytes');
          }

          // Verify this is actually an image by checking for common image headers
          if (bytes.length > 8) {
            // Check for JPEG header (FF D8)
            if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
              print('Detected JPEG image format');
              return bytes;
            }
            // Check for PNG header (89 50 4E 47)
            if (bytes[0] == 0x89 &&
                bytes[1] == 0x50 &&
                bytes[2] == 0x4E &&
                bytes[3] == 0x47) {
              print('Detected PNG image format');
              return bytes;
            }
            // Check for GIF header (47 49 46)
            if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
              print('Detected GIF image format');
              return bytes;
            }

            print(
              'Warning: No valid image header detected. First 8 bytes: [${bytes.take(8).map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}]',
            );
          }

          return bytes;
        } catch (e) {
          print('Base64 decoding error: $e');
          return null;
        }
      } catch (e) {
        print('Error in decodeBase64Image: $e');
        return null;
      }
    }


    print('\nProcessing front image...');
    if (  widget.dataCard.isBase64 == 1 &&
        widget.dataCard.cardFrontImageBase64 != null &&
        widget.dataCard.cardFrontImageBase64!.isNotEmpty) {
      final frontImage = decodeBase64Image(
        widget.dataCard.cardFrontImageBase64!,
      );
      if (frontImage != null) {
        images.add(frontImage);
        print('Successfully added front image');
      } else {
        print('Failed to decode front image');
      }
    }else if (widget.dataCard.cardFrontImageBase64 != null && widget.dataCard.cardFrontImageBase64!.isNotEmpty){
      imagesurl.add(widget.dataCard.cardFrontImageBase64);
      print('front Image Store in ImageUrl');

    }

    else {
      print('No front image data available');
    }

    print('\nProcessing back image...');
    if (widget.dataCard.isBase64 == 1 &&
        widget.dataCard.cardBackImageBase64 != null &&
        widget.dataCard.cardBackImageBase64!.isNotEmpty) {
      final backImage = decodeBase64Image(widget.dataCard.cardBackImageBase64!);
      if (backImage != null) {
        images.add(backImage);
        print('Successfully added back image');
      } else {
        print('Failed to decode back image');
      }
    }else if (widget.dataCard.cardBackImageBase64 != null && widget.dataCard.cardBackImageBase64!.isNotEmpty){
      imagesurl.add(widget.dataCard.cardBackImageBase64);
      print('Back Image Store in ImageUrl');
    }

    else {
      print('No back image data available');

    }

    print('\nFinal results:');
    print('Total images decoded: ${images.length}');
    print(Theme.of(context).cardColor);

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
        title: Text(
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
              Center(
                child: Container(
                  alignment: Alignment.center,
                  // color: Colors.grey.shade300,
                  // height: height * 0.4,
                  // color:Colors.red,
                  // width: width * 0.85,
                  child:
                     ( widget.dataCard.isBase64== 1
                         ? images.isNotEmpty
                         : imagesurl.isEmpty)
                          ? CarouselSlider(
                            carouselController: CarouselSliderController(),
                            options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              // height: height * 0.4,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              viewportFraction: 0.9,
                            ),
                            items:widget.dataCard.isBase64 == 1

                              ?  images.map((imgBytes) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        // decoration: BoxDecoration(
                                        //   color: Colors.grey[200],
                                        //   borderRadius: BorderRadius.circular(
                                        //     10,
                                        //   ),
                                        // ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: InteractiveViewer(
                                            minScale: 0.5,
                                            maxScale: 5.0,
                                            child: Image.memory(
                                              imgBytes,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList()

                               : imagesurl.map((url) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        // decoration: BoxDecoration(
                                        //   color: Colors.grey[200],
                                        //   borderRadius: BorderRadius.circular(
                                        //     10,
                                        //   ),
                                        // ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: InteractiveViewer(
                                            minScale: 0.5,
                                            maxScale: 5.0,
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                          )
                          : Icon(Icons.image, color: Colors.grey),
                ),
              ),

              // DotIndicator(pageController: pageController, pages: items),
              if ((widget.dataCard.isBase64==1 && images.isNotEmpty)
              ||
                  (widget.dataCard.isBase64 != 1 && images.isNotEmpty ))
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DotsIndicator(
                    dotsCount: widget.dataCard.isBase64== 1 ?images.length : imagesurl.length,
                    position: _currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Colors.blueAccent,
                      size: Size.square(9.0),
                      // activeSize: Size(12.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      spacing: EdgeInsets.all(4.0),
                    ),
                    // onTap: (postion){
                    //
                    // },
                  ),
                ),
              SizedBox(height: 20),

              // buttons
              Container(
                // color: Colors.red,
                width: width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Add button
                    InkWell(
                      onTap: () async {
                        try {
                          await SaveContact(
                            firstname: widget.dataCard.companyName ?? '',
                            email: widget.dataCard.companyEmail ?? '',
                            phone: widget.dataCard.companyPhoneNumber ?? '',
                            // lastName: widget.dataCard.ownerName ?? ''
                          );
                          showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text('Contact Saved',textAlign: TextAlign.center,style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),),
                                  content: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,

                                      ),
                                      child: Icon(Icons.check,color: Colors.white,size: 100,)),
                                  actions: [Center(
                                    child: TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    },
                                        child: Text('OK',style: GoogleFonts.poppins(fontSize: 18),)),
                                  )
                                  ],
                                );
                              });
                        } catch (e) {
                          print("Error during contact save: $e");
                        }

                      },

                      child: Column(
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
                    ),

                    // Share button
                    InkWell(
                      onTap: (){


                        _shareAllCardDetails();


                      },
                      child: Column(
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
                    ),

                    // Edit button
                    InkWell(
                      onTap: () async {


                        Navigator.push(context,MaterialPageRoute(builder: (context)=> EditCard(dataCard: widget.dataCard,)));
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
                          builder:
                              (context) => AlertDialog(
                                title: Text('Delete Card'),
                                content: Text(
                                  'Are you sure you want to delete this card?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
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


              // Company Section
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Business',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: Colors.indigo[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [

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
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.business,
                                color: Colors.blue[700],
                                size: 20,
                              ),
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

                          if (widget.dataCard.companyEmail != null &&
                              widget.dataCard.companyEmail!.isNotEmpty)
                            ListTile(
                              onTap: () {
                                // if(widget.dataCard.companyEmail!= null&&
                                //     widget.dataCard.companyEmail!.isNotEmpty){
                                //   sendmail(toEmail: widget.dataCard.companyEmail
                                //       .toString());
                                // }
                                if(widget.dataCard.companyEmail==null){
                                  sendmail(toEmail: widget.dataCard.companyEmail
                                            .toString());
                                }
                                // Handle company email tap
                              },
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
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

                          if (widget.dataCard.companyPhoneNumber != null && widget.dataCard.companyPhoneNumber!.isNotEmpty)
                            ...widget.dataCard.companyPhoneNumber!
                                .split(',')
                                .map(
                                  (phone) => ListTile(
                                onTap: () {
                              callNumber(phone.toString());

                               // callNumber(phone.split('+91-').toString());
                               //    callNumber(phone.replaceAll('+91-', '').trim());
                               //    callNumber('1234567890');
                               //    child: Text('Test Call');
                                },
                                    onLongPress: ()async{
                                  await Clipboard.setData(ClipboardData(text: phone.trim()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Copied To ClipBoard'))
                                  );
                                    },
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.green[700],
                                    size: 20,
                                  ),
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

                          if (widget.dataCard.companyAddress != null &&
                              widget.dataCard.companyAddress!.isNotEmpty)
                            ListTile(
                              onTap: () {

                              },
                              onLongPress: ()async{
                                await Clipboard.setData(ClipboardData(text: widget.dataCard.companyAddress!.join(', '),));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Copied To ClipBoard'))
                                );
                              },
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.orange[700],
                                  size: 20,
                                ),
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

                          if (widget.dataCard.companySWorkDetails != null &&
                              widget.dataCard.companySWorkDetails!.isNotEmpty)
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.work_outline,
                                  color: Colors.purple[700],
                                  size: 20,
                                ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              // People Section
              if (widget.dataCard.personDetails != null &&
                  widget.dataCard.personDetails!.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Text(
                              '${widget.dataCard.personDetails!.length} contacts',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                                              color: Colors.blue.withOpacity(
                                                0.1,
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.blue.withOpacity(
                                                  0.2,
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                person.name?.isNotEmpty == true
                                                    ? person.name![0]
                                                        .toUpperCase()
                                                    : '?',
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
                                                  border: Border.all(
                                                    color: Colors.grey[200]!,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.work_outline,
                                                  size: 12,
                                                  color: Colors.blue[700],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            (person.name== null || person.name!.trim().isEmpty || person.name!.toLowerCase()=='null')
                                                ? SizedBox()
                                                : Text(
                                              person.name!,
                                              // person.name!.contains('null') ? person.position.toString() : person.name.toString() ?? "N/A" ,
                                              style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            // Text(
                                            //   // person.name ?? 'N/A',
                                            //   person.name!.contains('null') ? person.position.toString() : person.name.toString() ?? "N/A" ,
                                            //   style: GoogleFonts.raleway(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w600,
                                            //     color: Colors.grey[800],
                                            //   ),
                                            // ),
                                            (person.position== null || person.position!.trim().isEmpty || person.position!.toLowerCase()=='null')
                                              ?SizedBox()
                                              :Container(
                                                margin: EdgeInsets.only(top: 4),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  person.position!,
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 12,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          // Show options menu
                                        },
                                      ),
                                    ],
                                  ),
                                  if (person.phoneNumber != null ||
                                      person.email != null)
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          if (person.phoneNumber != null)
                                            ListTile(
                                              onTap: () {
                                                callNumber(person.phoneNumber.toString());


                                              },
                                              onLongPress: ()async{
                                                await Clipboard.setData(ClipboardData(text: person.phoneNumber!,));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Copied To ClipBoard'))
                                                );
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              leading: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.phone_outlined,
                                                  color: Colors.green[700],
                                                  size: 18,
                                                ),
                                              ),
                                              title: Text(
                                                person.phoneNumber!,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                           (person.email== null || person.email!.trim().isEmpty || person.email!.toLowerCase()=='null')
                                          ?SizedBox()

                                            :ListTile(
                                              onTap: () {
                                                // Handle email tap
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              leading: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.email_outlined,
                                                  color: Colors.red[700],
                                                  size: 18,
                                                ),
                                              ),
                                              title: Text(
                                                person.email!,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  Icons.open_in_new,
                                                  color: Colors.grey[600],
                                                  size: 20,
                                                ),
                                                onPressed: () {

                                                  // if(person.email==null){
                                                  //   sendmail(toEmail: person.email.toString());
                                                  // }


                                               sendmail(
                                                 subject : '',
                                                 body: '',
                                                 toEmail: person.email!,
                                               // Subject: 'HelloFromVadilal',
                                               //   body: 'Test Mail'
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

// Add these imports at the top of your file
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import '../constant/colors.dart';

// Function to share business card image
void shareBusinessCardImage(BuildContext context,userData) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: primarycolor),
            const SizedBox(height: 16),
            const Text('Generating business card...'),
          ],
        ),
      );
    },
  );

  try {
    // Create and capture the business card widget
    final businessCardKey = GlobalKey();

    // Create the business card widget
    final businessCardWidget = RepaintBoundary(
      key: businessCardKey,
      child: buildBusinessCardWidgetAlternative(userData),
    );

    // Build the widget in a temporary overlay
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: -1000, // Position off-screen
        top: -1000,
        child: Material(
          color: Colors.transparent,
          child: businessCardWidget,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Wait for the widget to be built
    await Future.delayed(const Duration(milliseconds: 100));

    // Capture the widget as image
    RenderRepaintBoundary boundary = businessCardKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Remove the overlay
    overlayEntry.remove();

    // Close loading dialog
    Navigator.of(context).pop();

    // Save and share the image
    await _saveAndShareImage(pngBytes, context,userData);

  } catch (e) {
    // Close loading dialog if still open
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error generating business card: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


// Function to build business card using background image
Widget _buildBusinessCardWidget(userData) {
  return Container(
    width: 320,
    height: 500,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Background image - your pre-designed card
          Positioned.fill(
            child: Image.asset(
              'assets/images/card base.png', // Your background image path
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image doesn't load
                return Container(
                  color: Color(0xFFF5F5F5), // Light grey background
                  child: Center(
                    child: Text(
                      'Background image not found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),

          // Overlay with personal details
          Positioned(
            left: 0,
            right: 0,
            bottom: 180, // Position from bottom to place above company info
            child: Column(
              children: [
                // Personal name
                Text(
                  '${userData['firstname']} ${userData['lastname']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976D2), // Blue color
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8),

                // Designation
                Text(
                  userData['designation'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242), // Dark grey
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // Phone number
                Text(
                  userData['phoneno'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424242),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 6),

                // Email
                Text(
                  userData['email'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424242),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 15),

                // Additional info if needed
                Text(
                  'Ahmedabad-380058, Gujarat, India',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575), // Light grey
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Alternative version with different text positioning
Widget buildBusinessCardWidgetAlternative(userData) {
  return Container(
    width: 320,
    height: 500,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/card base.png',
              fit: BoxFit.cover,
            ),
          ),

          // Personal details positioned between hearts and Vadilal logo
          Positioned(
            left: 20,
            right: 20,
            top: 220+16, // Adjust this based on where you want text to appear
            child: Column(
              children: [
                // Name
                Text(
                  '${userData['firstname']} ${userData['lastname']}',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                  textAlign: TextAlign.center,
                ),

                // Designation
                // Text(
                //   userData['designation'],
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Color(0xFF424242),
                //     fontWeight: FontWeight.w500,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${userData['designation']??"-"}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 130-16),

                // Contact details
                Text(
                  userData['phoneno'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  userData['email'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


// Function to save and share the image
Future<void> _saveAndShareImage(Uint8List pngBytes, BuildContext context,userData) async {
  try {
    // Create a temporary file
    final tempDir = Directory.systemTemp;
    final file = await File('${tempDir.path}/business_card_${userData['firstname']}_${userData['lastname']}.png').create();
    await file.writeAsBytes(pngBytes);

    // Share the image file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Business Card - ${userData['firstname']} ${userData['lastname']}',
      subject: 'My Business Card',
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Business card image generated successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error sharing image: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Add this to your share options in _shareProfile function

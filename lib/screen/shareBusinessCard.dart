// Add these imports at the top of your file
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      child: _buildBusinessCardWidget(userData),
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

// Function to build the business card widget

// Function to build the business card widget with blue heart image
Widget _buildBusinessCardWidget(userData) {
  return Container(
    width: 350,
    height: 200,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primarycolor,
          primarycolor.withOpacity(0.8),
          HexColor('#0A4B94'),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Blue heart image on the right side middle
        Positioned(
          right: 20,
          top: 60, // Center vertically
          child: Container(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/Blue_heart_PNG.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Show a visible fallback - colorful hearts
                print('Image loading error: $error'); // Debug print
                return Container(
                  width: 80,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company branding area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vadilal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'serif',
                          ),
                        ),
                        Text(
                          'Since 1907',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Space for blue heart image
                  const SizedBox(width: 90),
                ],
              ),

              const Spacer(),

              // Personal information
              Container(
                width: 240, // Constrain width to avoid image overlap
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userData['firstname']} ${userData['lastname']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData['designation'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Contact information
                    Text(
                      userData['phoneno'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userData['email'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

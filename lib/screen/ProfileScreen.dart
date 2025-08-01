import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera_app/componets/snakbar.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screen/shareBusinessCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';
import '../util/const.dart';
import 'login1.dart';

class ProfileScreen extends StatelessWidget {
  // Your primary color
  final Color primaryColor = HexColor('#042E64');

  // Sample user data - replace with your actual user data from database
  final Map<String, dynamic> userData = appStore.userData!.toJson();

  ProfileScreen({Key? key}) : super(key: key);

final GlobalKey _qrkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Image
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: userData['profileimg'] != null ? NetworkImage(userData['profileimg']) : null,
                      child:
                          userData['profileimg'] == null
                              ? Text(
                                '${userData['firstname'][0]}${userData['lastname'][0]}',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    '${userData['firstname']} ${userData['lastname']}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Designation
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text(userData['designation'], style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Action Buttons
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: _buildActionButton(context, 'MY QR CODE', Icons.qr_code, Colors.white, primaryColor, () => _showQRCode(context))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(context, 'SHARE', Icons.share, Colors.white, const Color(0xFF1976D2), () => _shareProfile(context)),
                  ),
                ],
              ),
            ),

            // Profile Details
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  _buildProfileItem(Icons.email, 'Email', userData['email']),
                  _buildProfileItem(Icons.phone, 'Phone', userData['phoneno']),
                  _buildProfileItem(Icons.badge, 'User ID', userData['userid'].toString()),
                  _buildProfileItem(Icons.work, 'Role', userData['rolename'].toString()),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Logout Button
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon, Color textColor, Color backgroundColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryColor.withOpacity(0.3))),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 24), const SizedBox(height: 4), Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value, {Color? statusColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 16, color: statusColor ?? Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showQRCode(BuildContext context) {
    // Create QR data with user information
    String qrData = _generateQRData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My QR Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close), color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 20),

                // QR Code
                RepaintBoundary(
                  key: _qrkey,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // User Info
                Text('${userData['firstname']} ${userData['lastname']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(userData['designation'], style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 20),

                // Action Buttons
                ElevatedButton.icon(
                  onPressed: () => _shareQRCode(context,_qrkey),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: OutlinedButton.icon(
                //         onPressed: () => _copyQRData(context,qrData),
                //         icon: const Icon(Icons.copy, size: 18),
                //         label: const Text('Copy Data'),
                //         style: OutlinedButton.styleFrom(
                //           foregroundColor: primaryColor,
                //           side: BorderSide(color: primaryColor),
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         onPressed: () => _shareQRCode(context,_qrkey),
                //         icon: const Icon(Icons.share, size: 18),
                //         label: const Text('Share QR'),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: primaryColor,
                //           foregroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _generateQRData() {
    // Create a structured JSON-like string with user data
    return '''
BEGIN:VCARD
VERSION:3.0
FN:${userData['firstname']} ${userData['lastname']}
ORG:Vadilal Group
TITLE:${userData['designation']}
EMAIL:${userData['email']}
TEL:${userData['phoneno']}
UID:${userData['userid']}
END:VCARD
'''.trim();
  }

  void _copyQRData(BuildContext context, String qrData) {
    Clipboard.setData(ClipboardData(text: qrData));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [Icon(Icons.check_circle, color: Colors.white, size: 20), SizedBox(width: 8), Text('QR data copied to clipboard!')],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }



  // void _shareQRCode(BuildContext context, String qrData) {
  //   Navigator.of(context).pop();
  //  // Share.share(qrData, subject: '${userData['firstname']} ${userData['lastname']} - Contact Information');
  //  Share.share(qrData);
  // }
  //



  // Future<void> _copyQrImageToClipboard(BuildContext context, GlobalKey globalKey) async {
  //   try {
  //     // 1. Capture the widget as an image
  //     final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     final pngBytes = byteData!.buffer.asUint8List();
  //
  //     // 2. Use super_clipboard to create an image item
  //     final clipboard = SystemClipboard.instance;
  //     if (clipboard == null) {
  //       // Handle case where clipboard is not available
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Clipboard is not available on this platform.')),
  //       );
  //       return;
  //     }
  //
  //     final item = DataWriterItem();
  //     item.add(Formats.png(pngBytes));
  //     await clipboard.write([item]);
  //
  //     // 3. Close the dialog and show a confirmation message
  //     if (context.mounted) {
  //       Navigator.of(context).pop();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Row(
  //             children: [
  //               Icon(Icons.check_circle, color: Colors.white),
  //               SizedBox(width: 8),
  //               Text('QR Code image copied to clipboard!'),
  //             ],
  //           ),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Error copying image to clipboard: $e');
  //   }
  // }
  //



  Future<void> _shareQRCode(BuildContext context, GlobalKey globalKey) async {
    try {
      // 1. Capture the image from the widget
      final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 2. Save the image to the app's private temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);
      debugPrint('Image saved to: ${file.path}');

      // 3. Pop the dialog before sharing
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // 4. Create an XFile and share it
      final xFile = XFile(file.path, name: 'Contact_QR_Code.png', mimeType: 'image/png');

      await Share.shareXFiles(
        [xFile],
        text: 'Scan this QR code to get my contact details.',
        subject: 'Contact QR Code',
      );

    } catch (e) {
      debugPrint('Error sharing QR code: $e');
      if (context.mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error sharing QR Code: $e')),
        // );
      showCustomSnackbar(context, 'Error sharing QR Code: $e');

      }
    }
  }





  void _shareProfile(BuildContext context1) {
    String profileText = _generateProfileShareText();

    showModalBottomSheet(
      context: context1,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),

              // Title
              Text('Share Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
              const SizedBox(height: 16),

              // Share options
              _buildShareOption(context, Icons.text_fields, 'Share as Text', 'Share profile information as text', () => _shareAsText(profileText)),
              const SizedBox(height: 12),
              // _buildShareOption(
              //   context,
              //   Icons.email,
              //   'Share via Email',
              //   'Send profile information via email',
              //   () => _shareViaEmail(profileText, context),
              // ),
              // const SizedBox(height: 12),
              _buildShareOption(
                context,
                Icons.business_center,
                'Share Business Card',
                'Share as digital business card',
                () => shareBusinessCardImage(context1, userData),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }




  Widget _buildShareOption(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

//   String _generateProfileShareText() {
//     return '''
// 📋 CONTACT INFORMATION
//
// 👤 Name: ${userData['firstname']} ${userData['lastname']}
// 💼 Designation: ${userData['designation']}
// 🏢 Organization: Vadilal Group
// 📧 Email: ${userData['email']}
// 📱 Phone: ${userData['phoneno']}
//
// 💡 Connect with me for professional collaboration!
//
//
// ''';
//   }

  String _generateProfileShareText() {
    return '''
━━━━━━━━━━━━━━━━━━━━━━━
    𝐕𝐀𝐃𝐈𝐋𝐀𝐋 𝐆𝐑𝐎𝐔𝐏
━━━━━━━━━━━━━━━━━━━━━━━
 Name : ${userData['firstname']} ${userData['lastname']}
 Designation : ${userData['designation']}
 Email : ${userData['email']}
 Phone : ${userData['phoneno']}
━━━━━━━━━━━━━━━━━━━━━━━
''';
  }


  void _shareAsText(String profileText) {
    Share.share(profileText, subject: 'Contact Information - ${userData['firstname']} ${userData['lastname']}');
  }

  void _shareViaEmail(String profileText, BuildContext context) {
    Share.share(profileText, subject: 'Contact Information - ${userData['firstname']} ${userData['lastname']}');

    // Show additional info
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text('Choose email app from the sharing options')),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _shareBusinessCard() {
    String businessCardText = '''
╔══════════════════════════════════╗
║           BUSINESS CARD          ║
╠══════════════════════════════════╣
║                                  ║
║  ${userData['firstname']} ${userData['lastname']}                    ║
║  ${userData['designation']}            ║
║  Vadilal Group                   ║
║                                  ║
║  📧 ${userData['email']} ║
║  📱 ${userData['phoneno']}              ║
║                                  ║
╚══════════════════════════════════╝
''';

    Share.share(businessCardText, subject: 'Business Card - ${userData['firstname']} ${userData['lastname']}');
  }

  void _showLogoutDialog(BuildContext context) {
    showConfirmDialogCustom(
      context,
      title: "Do you want to logout?",
      primaryColor: primarycolor,
      dialogType: DialogType.CONFIRMATION,
      customCenterWidget: Container(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xffD6E0F5)),
        alignment: Alignment.center,
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA3BFE7)),
          alignment: Alignment.center,
          child: Icon(Icons.logout, color: primarycolor, size: 40),
        ),
      ),
      onAccept: (p0) async {
        logout(context);
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(TOKEN);
    prefs.setBool(IS_LOGGED_IN, false);
    prefs.remove('loginResponse');
    // prefs.remove()
    // await prefs.clear();

    // appStore.setUser(null);
    appStore.setIsLogin(false);
    appStore.setUserToken(null);

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }
}

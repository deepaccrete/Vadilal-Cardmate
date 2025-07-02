import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screen/Camera_Screen_2.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/addmanual.dart';
import 'package:camera_app/screen/home.dart';
import 'package:camera_app/screen/profile.dart';
import 'package:camera_app/screen/search.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../local_package/flutter_doc_scanner/flutter_doc_scanner.dart';
import 'groupandtags.dart';
import 'login1.dart';

class Bottomnav extends StatefulWidget {
  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _SelectedIndex = 0;



  Future<void>logout()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    appStore.setUser(null);
    appStore.setIsLogin(false);
    appStore.setUserToken(null);

    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_)=>
    LoginScreen()),
        (route) => false);

  }

  static final List<Widget> _WidgetOption = [
    HomeScreen(),
    // CameraScreen(),
    AddManual(),
    GroupAndTags(),
    LogOut(),
  ];

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      // case 1:
      //     return  CameraScreen();
      case 1:
        return AddManual();
      case 2:
        return GroupAndTags();

      case 3:
        return LogOut();
      default:
        return HomeScreen();
    }
  }

  void _onTap(int index) {
    if (index == 3) {
      // Show confirmation dialog instead of navigating
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: Text('Logout',textAlign: TextAlign.center,),
          content: Text('Are you sure you want to Logout?',textAlign: TextAlign.center),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap:(){
                    Navigator.pop(context);
                  } ,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primarycolor
                    ),
                    child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.white),)
                  ),
                ),
                InkWell(
                  onTap:() => logout(),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primarycolor
                    ),
                    child: Text('LogOut',style: GoogleFonts.poppins(color: Colors.white),)
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _SelectedIndex = index;
      });
    }
  }

  Widget buildCenterButton(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double buttonSize = width * 0.18; // 18% of screen width
    double borderWidth = buttonSize * 0.08;

    return Container(
      height: buttonSize,
      width: buttonSize,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF062A63), // Dark blue center
        border: Border.all(
          color: Color(0xFFB8C6F8), // Light blue outer glow
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.qr_code,
          color: Colors.white,
          size: buttonSize * 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showBottomNav = ![
      // CameraScreen, // or some screen where you want full view
    ].contains(_WidgetOption
    [_SelectedIndex].runtimeType);


    return Scaffold(
      extendBody: true,
      body: _WidgetOption[_SelectedIndex],
      bottomNavigationBar:
          showBottomNav
              ? Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 8,
                color: Colors.white,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          buildNavItem(Icons.home, "Home", 0),
                          SizedBox(width: 30),
                          buildNavItem(Icons.add, "Add", 1),

                        ],
                      ),
                      // SizedBox(width: 5,),
                      Row(
                        children: [
                          buildNavItem(Icons.search, "Group", 2),

                          SizedBox(width: 30),
                          buildNavItem(Icons.logout, "LogOut", 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                child: GestureDetector(
                  onTap: () {

                    _openScannerAndShowPreview(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen2()));
                    // CameraScreen2
                    // CameraScreen().launch(context);
                  },
                  child: buildCenterButton(context),
                ),
              ),
            ],
          )
              : null,
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    final isSelected = _SelectedIndex == index;
    final color = isSelected ? Colors.blue : Colors.black45;

    return GestureDetector(
      onTap:()=> _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Future<void> _openScannerAndShowPreview(BuildContext context) async {
  // This function is now self-contained and handles the entire scan-to-preview flow.

  // 1. Start the document scan
  final List<String>? imagePaths = await _startScanForPreview();
  if (imagePaths == null || imagePaths.isEmpty) {
    // User cancelled the scan or an error occurred.
    return;
  }

  // 2. If scan is successful, navigate to the preview screen.
  // The 'as BuildContext' is important if you are in a context that may be null.
  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen2(imagePaths: imagePaths),
      ),
    );
  }
}


Future<List<String>?> _startScanForPreview() async {
  try {
    final scanner = FlutterDocScanner();
    final dynamic result = await scanner.getScannedDocumentAsImages();

    print("[Preview Scan] Raw scan result: $result");

    if (result is Map && result.containsKey('Uri')) {
      final dynamic uriValue = result['Uri'];
      final List<String> paths = [];
      final regex = RegExp(r'imageUri=(file:///[^}]+)');

      if (uriValue is List && uriValue.isNotEmpty) {
        for (var page in uriValue) {
          final rawPageString = page.toString();
          final match = regex.firstMatch(rawPageString);
          if (match != null) paths.add(match.group(1)!.replaceFirst('file://', ''));
        }
      } else if (uriValue is String) {
        final matches = regex.allMatches(uriValue);
        for (final match in matches) {
          paths.add(match.group(1)!.replaceFirst('file://', ''));
        }
      }

      if (paths.isNotEmpty) return paths;
    }
  } catch (e, s) {
    print("[Preview Scan] ❗ Exception during scan: $e\n$s");
  }
  return null;
}


/*

import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/addmanual.dart';
import 'package:camera_app/screen/home.dart';
import 'package:camera_app/screen/profile.dart';
import 'package:camera_app/screen/search.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOption = [
    HomeScreen(),
    SearchScreen(),
    CameraScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOption,
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          _onTap(2); // Camera screen index
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.indigo[900],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.indigo[100]!, width: 5),
          ),
          child: const Icon(Icons.credit_card, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTabItem(icon: Icons.home_filled, index: 0, label: 'Home'),
              buildTabItem(icon: Icons.search, index: 1, label: 'Search'),
              const SizedBox(width: 40), // space for FAB
              buildTabItem(icon: Icons.shopping_cart_outlined, index: 3, label: 'Cart'),
              buildTabItem(icon: Icons.person_outline, index: 4, label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.indigo[900] : Colors.black45),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.indigo[900] : Colors.black45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
*/

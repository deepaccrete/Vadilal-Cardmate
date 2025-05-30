import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/cart.dart';
import 'package:camera_app/screen/home.dart';
import 'package:camera_app/screen/profile.dart';
import 'package:camera_app/screen/search.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Bottomnav extends StatefulWidget {
  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _SelectedIndex = 0;

  static final List<Widget> _WidgetOption =[
    HomeScreen(),
    SearchScreen(),
    // CameraScreen(),
    CartScreen(),
    ProfileScreen()
  ];


  Widget _getSelectedScreen(int index){
    switch (index) {
      case 0:
          return HomeScreen();
      // case 1:
      //     return  CameraScreen();
      case 1:
          return SearchScreen();
      case 2:
          return CartScreen();
      case 3:
          return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  void _onTap(int index){
    setState(() {
      _SelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showBottomNav = _SelectedIndex != 1; // hide on index 1

    return Scaffold(
      extendBody: showBottomNav, // Optional: for proper rendering with notch shadows
      body: _getSelectedScreen(_SelectedIndex),
      bottomNavigationBar: showBottomNav
          ? CircleNavBar(
        activeIcons: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.camera, color: Colors.white),
          Icon(Icons.logout, color: Colors.white),
        ],
        inactiveIcons: const [
          Column(
            children: [
              Icon(Icons.home, color: Color(0xff042E64)),
              Text("Home"),
            ],
          ),
          Column(
            children: [
              Icon(Icons.camera, color: Color(0xff042E64)),
              Text("Capture Card"),
            ],
          ),
          Column(
            children: [
              Icon(Icons.logout, color: Color(0xff042E64)),
              Text("Logout"),
            ],
          ),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 60,
        circleColor: Color(0xff042E64),
        activeIndex: _SelectedIndex,
        onTap: (index) {
          print("-----------------------------------$index");
      if(index == 1){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen()));
      }
         else if (index == 2) {
            showConfirmDialogCustom(
              context,
              title: "Do you want to logout from the app?",
              dialogType: DialogType.CONFIRMATION,
              centerImage: 'URL',
              onAccept: (p0) {},
            );
          } else {
            _onTap(index);
          }
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Color(0xff042E64),
        elevation: 10,
      )
          : null, // <--- Hide the bottom nav here
    );
  }
}


//
// import 'package:camera_app/constant/colors.dart';
// import 'package:camera_app/screen/camera_screen.dart';
// import 'package:camera_app/screen/cart.dart';
// import 'package:camera_app/screen/home.dart';
// import 'package:camera_app/screen/profile.dart';
// import 'package:camera_app/screen/search.dart';
// import 'package:flutter/material.dart';
//
// class Bottomnav extends StatefulWidget {
//   const Bottomnav({super.key});
//
//   @override
//   State<Bottomnav> createState() => _BottomnavState();
// }
//
// class _BottomnavState extends State<Bottomnav> {
//   int _selectedIndex = 0;
//
//   static final List<Widget> _widgetOption = [
//     HomeScreen(),
//     SearchScreen(),
//     CameraScreen(),
//     CartScreen(),
//     ProfileScreen()
//   ];
//
//   void _onTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _widgetOption,
//       ),
//       floatingActionButton: GestureDetector(
//         onTap: () {
//           _onTap(2); // Camera screen index
//         },
//         child: Container(
//           height: 70,
//           width: 70,
//           decoration: BoxDecoration(
//             color: Colors.indigo[900],
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.indigo[100]!, width: 5),
//           ),
//           child: const Icon(Icons.credit_card, color: Colors.white, size: 30),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 6,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               buildTabItem(icon: Icons.home_filled, index: 0, label: 'Home'),
//               buildTabItem(icon: Icons.search, index: 1, label: 'Search'),
//               const SizedBox(width: 40), // space for FAB
//               buildTabItem(icon: Icons.shopping_cart_outlined, index: 3, label: 'Cart'),
//               buildTabItem(icon: Icons.person_outline, index: 4, label: 'Profile'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTabItem({
//     required IconData icon,
//     required int index,
//     required String label,
//   }) {
//     final isSelected = _selectedIndex == index;
//     return GestureDetector(
//       onTap: () => _onTap(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: isSelected ? Colors.indigo[900] : Colors.black45),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.indigo[900] : Colors.black45,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

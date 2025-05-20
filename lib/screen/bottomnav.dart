import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/cart.dart';
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
  int _SelectedIndex = 0;

  static final List<Widget> _WidgetOption =[
    HomeScreen(),
    SearchScreen(),
    CameraScreen(),
    CartScreen(),
    ProfileScreen()
  ];


  Widget _getSelectedScreen(int index){
    switch (index) {
      case 0:
          return HomeScreen();
      case 1:
          return  SearchScreen();
      case 2:
          return CameraScreen();
      case 3:
          return CartScreen();
      case 4:
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
    return Scaffold(
      body: _getSelectedScreen(_SelectedIndex),

      // IndexedStack(
      // index: _SelectedIndex,
      // children: _WidgetOption,
      // ), //   onTap: (){
      //     _onTap(2);
      //   },
      //   child: Container(
      //     height: 70,
      //     width: 70,
      //     decoration: BoxDecoration(
      //       color: Colors.indigo[900],
      //       shape: BoxShape.circle,
      //       border:
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
      selectedLabelStyle: TextStyle(color: Colors.black),
          backgroundColor: Colors.black,
          currentIndex: _SelectedIndex,
          onTap: _onTap,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled,color: Colors.black,),
              activeIcon: Icon(Icons.home_filled,color: Colors.blue,),
              label: 'Home',
              backgroundColor: Colors.white
            ), BottomNavigationBarItem(
                icon: Icon(Icons.search,color: Colors.black,),
              activeIcon: Icon(Icons.search,color:  Colors.blue,),
              label: 'Search',
              backgroundColor: Colors.white
            ),BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined,color: Colors.black,),
              activeIcon: Icon(Icons.camera,color:  Colors.blue,),
              label: 'Camera',
              backgroundColor: Colors.white
            ), BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
              activeIcon: Icon(Icons.shopping_cart_outlined,color:  Colors.blue,),
              label: 'Cart',
              backgroundColor: Colors.white
            ), BottomNavigationBarItem(
                icon: Icon(Icons.person_outline,color: Colors.black,),
              activeIcon: Icon(Icons.person_outline,color:  Colors.blue,),
              label: 'profile',
              backgroundColor: Colors.white
            ),

          ]
      ),
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

import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/cart.dart';
import 'package:camera_app/screen/home.dart';
import 'package:camera_app/screen/profile.dart';
import 'package:camera_app/screen/search.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'login1.dart';

class Bottomnav extends StatefulWidget {
  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _SelectedIndex = 0;

  static final List<Widget> _WidgetOption = [
    HomeScreen(),
    SearchScreen(),
    // CameraScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  Widget _getSelectedScreen(int index) {
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

  void _onTap(int index) {
    setState(() {
      _SelectedIndex = index;
    });
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
    bool showBottomNav = _SelectedIndex != 1; // hide on index 1

    return Scaffold(
      extendBody: true,
      body: _getSelectedScreen(_SelectedIndex),
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
                          SizedBox(width: 40),
                          buildNavItem(Icons.search, "Search", 1),
                        ],
                      ),
                      Row(
                        children: [
                          buildNavItem(Icons.shopping_basket_outlined, "Cart", 3),
                          SizedBox(width: 40),
                          buildNavItem(Icons.person_outline, "Profile", 4),
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
                    CameraScreen().launch(context);
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
    final isSelected = 1 == index;
    final color = isSelected ? Colors.blue : Colors.black45;

    return GestureDetector(
      onTap: () => {},
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

/*

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

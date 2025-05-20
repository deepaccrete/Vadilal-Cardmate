import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        // color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Top-left
            Positioned(top: 100, left: 40, child: _corner(isTop: true, isLeft: true)),
// Top-right
            Positioned(top: 100, right: 40, child: _corner(isTop: true, isLeft: false)),
// Bottom-left
            Positioned(bottom: 100, left: 40, child: _corner(isTop: false, isLeft: true)),
// Bottom-right
            Positioned(bottom: 100, right: 40, child: _corner(isTop: false, isLeft: false)),

            // Texts
            Positioned(left: 0, top: MediaQuery.of(context).size.height * 0.35, child: RotatedBox(quarterTurns: 3, child: Text("This side down", style: TextStyle(color: Colors.white)))),
            Positioned(right: 0, top: MediaQuery.of(context).size.height * 0.35, child: RotatedBox(quarterTurns: 1, child: Text("This side up", style: TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }
  Widget _corner({required bool isTop, required bool isLeft}) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          // Horizontal line
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              color: Colors.white,
            ),
          ),
          // Vertical line
          Positioned(
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}

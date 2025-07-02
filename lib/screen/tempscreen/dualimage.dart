import 'dart:io';

import 'package:flutter/material.dart';

class Dualimage extends StatefulWidget {
  final String frontImage;
  final String backImage;
  const Dualimage({super.key, required this.frontImage, required this.backImage});

  @override
  State<Dualimage> createState() => _DualimageState();
}

class _DualimageState extends State<Dualimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Front & Back Preview',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16),
          child:Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Front-Side'),
                Container(
                  // color: Colors.red,
        
                  alignment: Alignment.center,
                  height: 200,
                  width: 900,
                  child: Image.file(File(widget.frontImage),fit:  BoxFit.contain,),),
            SizedBox(height: 16,),
                Text('Back-Side'),
                Container(
        //                color: Colors.red,
                  alignment: Alignment.center,
                    height: 200,
                    width: 900,
                    child: Image.file(File(widget.backImage),fit: BoxFit.contain,)),
              SizedBox(height: 24,),
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pop(context,false);
                    }, label: Text('Retake Both'),
                  icon: Icon(Icons.refresh),
                )
              ],
                  ),
          ) ,),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final String imagePath;
  final String initialText;
  // final String? backImagePath;
  const ImagePreview({super.key, required this.imagePath, required this.initialText, });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _textController = TextEditingController(text: widget.initialText);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Preview',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 900,
                child: Image.file(File(widget.imagePath), fit: BoxFit.contain,),
              ),
              SizedBox(height:20),
        
              TextFormField(
                controller: _textController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Detected Text',
                ),
              ),
              SizedBox(height: 20,),
        
              ElevatedButton.icon(
                  onPressed:(){
                    Navigator.pop(context, false);
                  }, icon: Icon(Icons.refresh),
              label: Text('Retake'),
              ),
              SizedBox(height: 50,),
              // widget.backImagePath!=null?
              // Container(
              //   height: 200,
              //   width: 300,
              //   child: Image.file(File(widget.backImagePath!), fit: BoxFit.contain,),
              // ):SizedBox(height: 20,)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton.icon(onPressed: (){}, label: Text('Retake'),
              //       icon: Icon(Icons.refresh),
              //          ),
              //     ElevatedButton.icon(onPressed: (){
              //
              //     }, label: Text('use '),
              //       icon: Icon(Icons.refresh),
              //          ),
              //   ],
              // ),
              // SizedBox(height: 16,)
            ],
          ),
        ),
      ),
    );
  }
}

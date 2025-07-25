// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';

class CommonTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onfieldsumbitted;
  final Icon? icon;
  final Widget? gesture;
  final String? hintText;
  final String? labeltext;
  final Color? BorderColor;
  final Color? HintColor;
  final Color? labelColor;
  final double? borderc;
  final double? heightTextform;
  final double? widthTextform;
  final double? contentpadding;
  final int? maxline;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final bool? symetric;

  // final String? labelText;
  final bool obsecureText;
  const CommonTextForm(
      {super.key,
        this.fillColor,
        this.controller,
        this.keyboardType,
        this.hintText,
        required this.obsecureText,
        this.validator,
        this.icon,
        this.gesture,
        this.focusNode,
        this.onfieldsumbitted,
        this.BorderColor,
        this.HintColor,
        this.borderc,
        this.heightTextform,
        this.widthTextform,
        this.maxline,
        this.contentpadding,
        this.symetric, this.labeltext, this.labelColor,
      });



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Container(
      height: heightTextform,
      width: widthTextform,
      child: TextFormField(
        maxLines:maxline,
        keyboardType: keyboardType??TextInputType.text,
        onFieldSubmitted:onfieldsumbitted ,
        validator: validator,
        obscureText: obsecureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500, color: labelColor ?? Colors.black),
          filled: true,
          fillColor: fillColor,
          contentPadding:  symetric==true?EdgeInsets.symmetric(horizontal: contentpadding ?? 0 ,) :EdgeInsets.all(contentpadding ?? 0),
          suffixIcon: gesture,
          // labelText: labelText,
          hintText: hintText,
          prefixIcon: icon,
          hintStyle: GoogleFonts.poppins(
            fontSize: 12,
              fontWeight: FontWeight.w500, color: HintColor ?? Colors.black),
          // label: labelText,
          focusedBorder:
          OutlineInputBorder(
              borderSide: BorderSide(
                  color: BorderColor ?? primarycolor
              ),
              borderRadius: BorderRadius.circular(borderc??15)),
          enabledBorder:
          OutlineInputBorder(
              borderSide: BorderSide(
                  color: BorderColor ?? Colors.black
              ),
              borderRadius: BorderRadius.circular(borderc??15)),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderc??15),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderc??15)),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderc??15),
          ),


        ),
      ),
    );
  }
}


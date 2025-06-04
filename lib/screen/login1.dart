import 'dart:convert';

import 'package:camera_app/componets/button.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/AuthAPI.dart';
import '../main.dart';
import '../util/const.dart';
import 'bottomnav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emaiilFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final _formkey = GlobalKey<FormState>();

  final outborder = OutlineInputBorder(
    // borderSide: BorderSide(color: primarycolor),
    borderRadius: BorderRadius.circular(10),
  );

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (!EmailValidator.validate(value)) {
      return 'Enter a valid email';
    }

    // // Simple email regex
    // final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    //
    // if (!emailRegex.hasMatch(value)) {
    //   return 'Enter a valid email';
    // }

    return null; // Valid
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    ValueNotifier obsecurepass = ValueNotifier(true);
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      backgroundColor: primarycolor,

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: Column(
            children: [
              Container(
                // alignment: Alignment.bottomCenter,
                height: height * 0.1,
                width: width * 0.5,
                decoration: BoxDecoration(
                  // color: Colors.red
                ),
                child:Image.asset('assets/images/logov.png',fit: BoxFit.fill,),
              ),
              SizedBox(height: 10,),
              Container(
                height: height * 0.16,
                width: width,
                decoration: BoxDecoration(
                  // color: Colors.red
                ),
                child:Image.asset('assets/images/Sign up (1).png'),
              ),

              SizedBox(height: 50,),

              Container(
                // color: Colors.red,
                child: Text('Login to Your Account',textScaler: TextScaler.linear(1.2),style: GoogleFonts.openSans(color: Colors.white,fontSize: 20),),
              ),
              SizedBox(height: 25,),


              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Email Address',style: GoogleFonts.openSans(color: Colors.white),),
                    SizedBox(height: 10,),
                    Container(
                      // color: Colors.red,
                      // height: height * 0.1,
                      width: width * 0.8,
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        focusNode: emaiilFocus,
                        onFieldSubmitted: (value) {
                          FocusScope.of(
                            context,
                          ).requestFocus(passwordFocus);
                        },
                        validator: validateEmail,
                        decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                          filled: true,
                          hintText: 'Enter Email',
                          fillColor: Colors.white,
                         enabledBorder: outborder,
                          disabledBorder: outborder,
                          focusedBorder: outborder,
                          errorBorder: outborder,
                          focusedErrorBorder: outborder
                          )
                        ),
                      ),

                    SizedBox(height: 10,),
                    Text('Password',style: GoogleFonts.openSans(color: Colors.white),),
                    SizedBox(height: 10,),
                    ValueListenableBuilder(

                      valueListenable: obsecurepass,
                      builder: (BuildContext context, value,child) {
                      return  Container(
                        // color: Colors.red,
                        // height: height * 0.1,
                        width: width * 0.8,
                        child: TextFormField(
                          focusNode: passwordFocus,
                          controller: passwordController,
                          obscureText: obsecurepass.value,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 4) {
                              return "Please Enter Password";
                              // :"Please enter "
                            }
                          },

                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical:15,horizontal: 15),
                              hintText: 'Enter password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  obsecurepass.value = !obsecurepass.value;
                                },
                                child:
                                obsecurepass.value == true
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                            filled: true,
                            fillColor: Colors.white,
                              enabledBorder: outborder,
                              disabledBorder: outborder,
                              focusedBorder: outborder,
                              errorBorder: outborder,
                              focusedErrorBorder: outborder
                          ),
                        ),
                      );
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),


              CommonButton(
                width: width * 0.8,
                  bgcolor: Colors.indigoAccent,
                  onTap: () {
                    loginReq();
                  },

                  child:Text('Login',style: GoogleFonts.openSans(color: Colors.white,fontSize: 20),)),

              SizedBox(height: 10,),

              Text('Forget User / Password',style: GoogleFonts.openSans(fontSize: 18,color: Colors.grey),)
            ],
          ),
        ),
      ),

    );
  }
  loginReq() async {
    if (_formkey.currentState!.validate()) {
      try {
        final loginResponse = await AuthApi.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (loginResponse.success == 1) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString(TOKEN, loginResponse.userData?.token ?? '');
          await pref.setBool(IS_LOGGED_IN, true);
          String userDetailsString = jsonEncode(loginResponse.userData);
          await pref.setString(USER_DETAIL, userDetailsString);
          appStore.setUserToken(loginResponse.userData?.token);
          appStore.setIsLogin(true);
          appStore.setUser(loginResponse.userData);

          print("Login success");
          //
          // if (!context.mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginResponse.msg ?? 'Invalid credentials')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

}

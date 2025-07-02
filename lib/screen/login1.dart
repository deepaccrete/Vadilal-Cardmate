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
import 'package:flutter_mobx/flutter_mobx.dart';
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
  bool? isLoading = false;
  ValueNotifier obsecurepass = ValueNotifier(true);

  final _formkey = GlobalKey<FormState>();

  final outborder = OutlineInputBorder(
    // borderSide: BorderSide(color: primarycolor),
    borderRadius: BorderRadius.circular(10),
  );

  String? validateEmail(String? value) {

    if (value == null || value.isEmpty) {
      return 'Please enter your email address.';
    }

    final trimmedValue = value.trim();

    if (!EmailValidator.validate(trimmedValue)) {
      return 'Please enter a valid email address.';
    }

    // // Simple email regex
    // final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    //
    // if (!emailRegex.hasMatch(value)) {
    //   return 'Enter a valid email';
    // }

    return null; // Valid
  }

  bool rememberme = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    emaiilFocus.dispose();
    obsecurepass.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Rebuild ');

    final width = MediaQuery
        .of(context)
        .size
        .width * 1;
    final height = MediaQuery
        .of(context)
        .size
        .height * 1;

    return Scaffold(
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [

              // lOGO
              Container(
                height: height * 0.1,
                width: width * 0.5,
                child: Image.asset(
                  'assets/images/logovadilal.png', fit: BoxFit.fill,),
              ),
              SizedBox(height: 10,),
              Container(
                height: height * 0.16,
                width: width,
                child: Image.asset('assets/images/Sign up (1).png'),
              ),
              SizedBox(height: 50,),

              // LOGInText
              Container(
                // color: Colors.red,
                child: Text(
                  'Login to Your Account', textScaler: TextScaler.linear(1.2),
                  style: GoogleFonts.openSans(
                      color: Colors.white, fontSize: 20),),
              ),
              SizedBox(height: 25,),


              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email Address',
                      style: GoogleFonts.openSans(color: Colors.white),),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 15,
                                  horizontal: 15),
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
                    Text('Password',
                      style: GoogleFonts.openSans(color: Colors.white),),
                    SizedBox(height: 10,),
                    ValueListenableBuilder(

                        valueListenable: obsecurepass,
                        builder: ( context, value, child) {
                          return Container(
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
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
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
                    Container(
                      // padding:EdgeInsets.all(10),
                      // color: Colors.red,
                      width: width * 0.8,

                      // alignment: Alignment.bottomLeft,
                      // padding:EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(

                              value: rememberme,
                              onChanged: (value) {
                                setState(() {
                                  rememberme = value!;
                                });
                              }),
                          Text('Remember Me', style: GoogleFonts.poppins(
                              color: Colors.white),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 25,),


              Observer(
                builder: (_) => CommonButton(
                  width: width * 0.8,
                  bgcolor: Colors.indigoAccent,
                  onTap: () {
                    loginReq();
                  },
                  child: Center(
                    child: appStore.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Login', style: GoogleFonts.openSans(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ),


              SizedBox(height: 10,),

              Text('Forget User / Password',
                style: GoogleFonts.openSans(fontSize: 18, color: Colors.grey),)
            ],
          ),
        ),
      ),

    );
  }

  loginReq() async {
    if (_formkey.currentState!.validate()) {
      // setState(() {
      //   // isLoading = true;
      //   appStore.isLoading = true;
      // });
      // appStore.isLoading = true;

      try {
        // appStore.isLoading = true;
        appStore.setIsLoading(true);

        final loginResponse = await AuthApi.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (loginResponse.success == 1) {

          if (rememberme) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.setString(TOKEN, loginResponse.userData?.token ?? '');
            await pref.setBool(IS_LOGGED_IN, true);
            String userDetailsString = jsonEncode(loginResponse.userData);
            await pref.setString(USER_DETAIL, userDetailsString);
          }

          appStore.setUserToken(loginResponse.userData?.token);
          appStore.setIsLogin(true);
          appStore.setUser(loginResponse.userData);
    // setState(() {
    //   isLoading = false;
    // });

          // appStore.isLoading = false;
          appStore.setIsLoading(false);


          print("Login success");
          //
          // if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Bottomnav()),
          );
        } else {
        // setState(() {
        //   isLoading = false;
        // });
        //   appStore.isLoading = false;
          appStore.setIsLoading(false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.grey.shade100,
                showCloseIcon: true,
                content: Text(loginResponse.msg ?? 'Invalid credentials',textAlign:TextAlign.center ,style: GoogleFonts.poppins(color: Colors.black,
                fontWeight: FontWeight.w500),)),);

        }
      } catch (e) {
        // setState(() {
        //   isLoading = false;
        // });
        // appStore.isLoading = false;
        appStore.setIsLoading(false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

}

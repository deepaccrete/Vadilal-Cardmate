import 'dart:convert';
import 'package:camera_app/componets/button.dart';
import 'package:camera_app/componets/snakbar.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
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

  bool rememberMe = false;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserEmailPass();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [

              // lOGO
              Container(
                // height: height * 0.1,
                width: width * 0.4,
                child: Image.asset('assets/images/Blue_heart_PNG.png', fit: BoxFit.fill),
              ),

              SizedBox(height: 10),

              // logo
              Container(height: height * 0.16, width: width,
                  child: Image.asset('assets/images/Sign up (1).png')),

              SizedBox(height: 50),

              // LOGInText
              Container(
                // color: Colors.red,
                child: Text(
                  'Login to Your Account',
                  textScaler: TextScaler.linear(1.2),
                  style: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
                ),
              ),

              SizedBox(height: 25),

              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email Address', style: GoogleFonts.openSans(color: Colors.white)),
                   const SizedBox(height: 10),
                    Container(
                      // color: Colors.red,
                      // height: height * 0.1,
                      width: width * 0.8,
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        focusNode: emaiilFocus,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        validator: validateEmail,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          filled: true,
                          hintText: 'Enter Email',
                          fillColor: Colors.white,
                          enabledBorder: outborder,
                          disabledBorder: outborder,
                          focusedBorder: outborder,
                          errorBorder: outborder,
                          focusedErrorBorder: outborder,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Text('Password', style: GoogleFonts.openSans(color: Colors.white)),
                    SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: obsecurepass,
                      builder: (context, value, child) {
                        return Container(
                          // color: Colors.red,
                          // height: height * 0.1,
                          width: width * 0.8,
                          child: TextFormField(
                            focusNode: passwordFocus,
                            controller: passwordController,
                            obscureText: obsecurepass.value,
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length < 4) {
                                return "Please Enter Password";
                                // :"Please enter "
                              }
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              hintText: 'Enter password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  obsecurepass.value = !obsecurepass.value;
                                },
                                child: obsecurepass.value == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outborder,
                              disabledBorder: outborder,
                              focusedBorder: outborder,
                              errorBorder: outborder,
                              focusedErrorBorder: outborder,
                            ),
                          ),
                        );
                      },
                    ),

                    // rememberMe
                    Container(
                      width: width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            side: BorderSide(color: Colors.white),

                            //     activeColor: Colors.red,
                            // focusColor: Colors.green,
                            // checkColor: Colors.white,
                            value: rememberMe,
                            onChanged: _handleRemember,
                          ),
                          //   (value) {
                          // setState(() {
                          //   rememberme = value!;});}),
                          Text('Remember Me', style: GoogleFonts.poppins(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // login
              Observer(
                builder:
                    (_) => CommonButton(
                      width: width * 0.8,
                      bgcolor: Colors.indigoAccent,
                      onTap: () {
                        loginReq();
                      },
                      child: Center(
                        child:
                            appStore.isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Login', style: GoogleFonts.openSans(color: Colors.white, fontSize: 20)),
                      ),
                    ),
              ),

              SizedBox(height: 10),

              // Text('Forget User / Password', style: GoogleFonts.openSans(fontSize: 18, color: Colors.grey)),
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
      appStore.setIsLoading(true);

      try {
        // appStore.isLoading = true;

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
          String appSettingString = jsonEncode(loginResponse.appsetting);
          await pref.setString(APP_SETTING, appSettingString);
          appStore.setUserToken(loginResponse.userData?.token);
          appStore.setIsLogin(true);
          appStore.setUser(loginResponse.userData);
          appStore.setAppSetting(loginResponse.appsetting);
          // setState(() {
          //   isLoading = false;
          // });

          // appStore.isLoading = false;
          appStore.setIsLoading(false);

          print("Login success");
          appStore.setEmail(emailController.text);
          appStore.setPassword(passwordController.text);
          //
          // if (!context.mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnav()));
        } else {
          // setState(() {
          //   isLoading = false;
          // });
          //   appStore.isLoading = false;
          appStore.setIsLoading(false);

          showCustomSnackbar(context,    loginResponse.msg ?? 'Invalid credentials',);

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.grey.shade100,
          //     showCloseIcon: true,
          //     content: Text(
          //       loginResponse.msg ?? 'Invalid credentials',
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500),
          //     ),
          //   ),
          // );
        }
      } catch (e) {
        // setState(() {
        //   isLoading = false;
        // });
        appStore.setIsLoading(false);

        // appStore.isLoading = false;

        showCustomSnackbar(context,'An error occurred. Please try again.' );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again.')));
      }
    }
  }

  void _handleRemember(bool? value) async
  {
    try {
      print('Handle Remember Me');
      rememberMe = value!;
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("Remember_Me_Key", value);
      if (rememberMe) {
        await pref.setString("Saved_Email", emailController.text);
        await pref.setString("Saved_Password", passwordController.text);

        appStore.setIsRememberMe(true);
        appStore.setEmail(emailController.text);
        appStore.setPassword(passwordController.text);
      } else {
        pref.remove(Saved_Email);
        pref.remove(Saved_Password);

        appStore.setEmail(null);
        appStore.setPassword(null);
      }
      appStore.setIsRememberMe(value);
      setState(() {
        rememberMe = value;
      });
    } catch (e) {
      print('Handle Remember ==>');
    }
  }

  void loadUserEmailPass() async {
    print("Load Email and Password");
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var _rememberme = pref.getBool("Remember_Me_Key") ?? false;

      if (_rememberme) {
        setState(() {
          rememberMe = true;
        });
        var _email = pref.getString("Saved_Email") ?? '';
        var _password = pref.getString("Saved_Password") ?? '';
        emailController.text = _email ?? "";
        passwordController.text = _password ?? "";

        appStore.setEmail(_email);
        appStore.setPassword(_password);
        setState(() {});
      } else {
        setState(() {
          rememberMe = false;
        });
        emailController.text = '';
        passwordController.text = '';

        appStore.setEmail(null);
        appStore.setPassword(null);
      }
    } catch (e) {
      print('Error Load Email And Pass =>> $e');
    }
  }
}

//
// Expanded(
// child: Column(crossAxisAlignment: CrossAxisAlignment.start,
// children: [
//
// ...card.personDetails!.map(
// (
// person,
// ) =>
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// (person.name == null ||
// person.name!.trim().isEmpty ||
// person.name!.toLowerCase() == 'null')
// ?      Text(
// // card.companyAddress!.join(',') ?? "No Data",
// card.companyName ??
// '',
// style: GoogleFonts.raleway(
// fontWeight:
// FontWeight.w600,
// fontSize:
// 14,
// color:
// Colors.black,
// ),
// )
//     : Text(
// person.name ??
// 'No data',
// style: GoogleFonts.raleway(
// fontWeight:
// FontWeight.w600,
// fontSize:
// 14,
// color:
// Colors.black,
// ),
// ),
// // SizedBox(
// //   width:
// //       5,
// // ),
//
// (person.position ==
// null ||
// person.position!.trim().isEmpty ||
// person.position!.toLowerCase() ==
// 'null')
// ? SizedBox()
//
//
//     :  Container(
// margin: EdgeInsets.only(top: 4),
// padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// decoration: BoxDecoration(
// color: Colors.blue.withAlpha(20),
// borderRadius: BorderRadius.circular(4),
// ),
// child: Text(
// person.position!.toUpperCase(),
// style: GoogleFonts.raleway(fontSize: 12, color: Colors.blue[700]),
// ),
// ),
//
// // : Text(
// //   person.position!.toUpperCase() ??
// //       '',
// //   style: GoogleFonts.raleway(
// //     fontWeight:
// //         FontWeight.w600,
// //     fontSize:
// //         12,
// //     color:
// //         Colors.grey.shade900,
// //   ),
// // ),
// ],
// ),
// ),
// SizedBox(
// height: 5,
// ),
//
//
// ...card.personDetails!.map((person)=>
//
// (
// (person.name ==
// null ||
// person.name!.trim().isEmpty ||
// person.name!.toLowerCase() ==
// 'null')
// // (person.phoneNumber == null ||
// //         person.phoneNumber!.trim().isEmpty ||
// //         person.phoneNumber!.toLowerCase() == 'null')
// //     ? SizedBox()
// //     :))
// ?SizedBox()
//     :Text(
// // card.companyAddress!.join(',') ?? "No Data",
// card.companyName ??
// '',
// style: GoogleFonts.raleway(
// fontWeight:
// FontWeight.w500,
// fontSize:
// 14,
// color:
// subtext,
// ),
// ))
//
// )],
// ),
// ),
//
//

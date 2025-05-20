import 'package:camera_app/componets/button.dart';
import 'package:camera_app/componets/textform.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final outborder = OutlineInputBorder(
    borderSide: BorderSide(color: primarycolor),
      borderRadius: BorderRadius.circular(10));

  FocusNode emaiilFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    ValueNotifier obsecurepass = ValueNotifier(true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Container(
                height: height,
                // width: width,
                child: Image.asset(
                  'assets/images/backimg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Opacity(
              opacity: 0.3,
              child: Container(height: height, color: Colors.white),
            ),
            Container(
              // color: screenBGColor,
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //logo
                  Container(
                    // color: Colors.red,
                    alignment: Alignment.bottomCenter,
                    width: width,
                    height: height * 0.2,
                    child: Image.asset(
                      'assets/images/bg.png',
                      height: 182,
                      width: 182,
                    ),
                  ),

                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    // color: Colors.greenAccent,
                    height: height * 0.15,
                    child: Text(
                      'Hello!',
                        textAlign: TextAlign.end,
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false
                        )
                        ,textScaler: TextScaler.linear(1.0),
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontSize: 90,
                        color: primarycolor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'Login to your account',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    // color: Colors.red,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: secondcolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                             controller: emailController,
                             obscureText: false,
                             focusNode: emaiilFocus,
                             onFieldSubmitted: (value) {
                               FocusScope.of(
                                 context,
                               ).requestFocus(passwordFocus);
                             },
                             validator: (value) {
                               if (value == null || value.isEmpty) {
                                 return "Please Enter Email";
                               }
                             },
                             decoration: InputDecoration(
                               filled: true,
                               contentPadding: EdgeInsets.all(5),
                               fillColor: Colors.white,
                               focusColor: Colors.white,
                               hintText: 'Enter Email Address',
                               // label: Icon(Icons.email_outlined,color: primarycolor,),
                               prefixIcon: Icon(
                                 Icons.email_outlined,
                                 color: primarycolor,
                               ),
                               enabledBorder: outborder,
                               disabledBorder: outborder,
                               focusedBorder: outborder,
                               errorBorder: outborder,
                               focusedErrorBorder: outborder,
                             ),
                           ),

                          SizedBox(height: 20),
                          Text(
                            'Password',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: secondcolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          ValueListenableBuilder(
                            valueListenable: obsecurepass,
                            builder: (context, value, child) {
                              return TextFormField(
                                focusNode: passwordFocus,
                                controller: passwordController,
                                obscureText: obsecurepass.value,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return "Please Enter Password";
                                    // :"Please enter "
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(5),
                                  hintText: 'Enter Password',
                                  // label: Icon(Icons.email_outlined,color: primarycolor,),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: primarycolor,
                                  ),
                                  enabledBorder: outborder,
                                  disabledBorder: outborder,
                                  focusedBorder: outborder,
                                  errorBorder: outborder,
                                  focusedErrorBorder: outborder,

                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      obsecurepass.value =
                                          !obsecurepass.value;
                                    },
                                    child:
                                        obsecurepass.value == true
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Forget password
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Forget Password?',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: primarycolor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: CommonButton(
                              bordercircular: 7,
                              height: height * 0.07,
                              width: width * 0.75,
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Bottomnav(),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'LOG IN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          // Center(
                          //   child: RichText(
                          //       textAlign: TextAlign.center,
                          //       text: TextSpan(
                          //     text: "Don't have an account? ",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                          //     children: [
                          //       TextSpan(
                          //         text: 'Sign up now',style: TextStyle(color: primarycolor,fontWeight: FontWeight.w400,fontSize: 14)
                          //       )
                          //     ]
                          //   )),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// purple ui
/* Card(
                          elevation: 6,
                          shadowColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Color(0xFFE3D9FF), Color(0xFFD1C1FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    color: Color(0xFF6C5CE7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CommonTextForm(
                                  fillColor: Colors.white,
                                  labelColor: Colors.grey[500],
                                  contentpadding: 10,
                                  focusNode: phonenode,
                                  controller: phoneController,
                                  labeltext: 'Phone Number',
                                  borderc: 20,
                                  BorderColor: Color(0xFF6C5CE7),
                                  icon: Icon(Icons.phone, color: Color(0xFF6C5CE7)),
                                  obsecureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter Name";
                                    }
                                    return null;
                                  },
                                  onfieldsumbitted: (value) {
                                    FocusScope.of(context).requestFocus(desinationnode);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),*/



// Ui changed
/*  body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //text card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Card Front',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: primarycolor
                  ),
                ),
              ),
              SizedBox(height: 5,) ,
              // img
              Center(
                child: Container(
                  // alignment: Alignment.center,
                  height: height * 0.2,
                  width: width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,

                  ),
                  child: Icon(Icons.image, color: Colors.grey[500],size: 50,),
                ),
              ),
              SizedBox(height: 5,) ,

              // Card Details

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Text(
                  'Card Details',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: primarycolor
                  ),
                               ),
               ),
              SizedBox(height: 5,) ,


              Card(
                surfaceTintColor: Colors.transparent, // <- This disables tinting
                shadowColor: Colors.black.withValues(alpha: 1), // manually define shadow
                color:Colors.grey.shade50 ,
                elevation: 15,
                child: Container(
                  // color:Colors.grey[100],

                  padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Bussiness Tags',
                          //   style: GoogleFonts.inter(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 14,
                          //   ),
                          // ),
                          //
                          // // General
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => GroupAndTags(),
                          //       ),
                          //     );
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(
                          //       horizontal: 10,
                          //       vertical: 5,
                          //     ),
                          //     height: height * 0.06,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //       border: Border.all(color: Colors.grey),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Text(
                          //           'General',
                          //           style: GoogleFonts.poppins(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //         Icon(Icons.keyboard_arrow_down),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                           Text(
                             'FULL NAME',
                             textAlign: TextAlign.start,
                             style: GoogleFonts.raleway(
                               fontSize: 14,
                               color:primarycolor,
                               fontWeight: FontWeight.w700,
                             ),
                           ),
                           SizedBox(height: 5),
                           CommonTextForm(
                             // heightTextform: ,
                             // widthTextform: width * 0.65,
                             fillColor: Colors.white,
                             labelColor: Colors.grey,
                             borderc: 5,
                             BorderColor: Colors.grey,
                             symetric: true,
                             contentpadding: 5,
                             focusNode: namenode,
                             controller: nameController,
                             // heightTextform: height * 0.08,
                             labeltext: 'Full Name',
                             icon: Icon(Icons.person_outline,color: primarycolor,),
                             obsecureText: false,
                             validator: (value) {
                               if (value == null || value.isEmpty) {
                                 return "please Enter Name";
                               }
                             },
                             onfieldsumbitted: (value){
                               FocusScope.of(context).requestFocus(desinationnode);
                             },
                           ),

                         /* Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFDEC9E3),

                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.work,
                                        // color: Colors.blue[700],
                                        color: primarycolor,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      'Designation',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                  SizedBox(height: 5),
                                  CommonTextForm(
                                    symetric: true,
                                    fillColor: Colors.grey[100],
                                    HintColor: Colors.grey[600],
                                    contentpadding: 10,
                                    focusNode: namenode,
                                    controller: nameController,
                                    // heightTextform: height * 0.08,
                                    hintText: 'XYZ Person',
                                    borderc: 10,
                                    BorderColor: Colors.grey,
                                    // icon: Icon(Icons.person_outline),
                                    obsecureText: false,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "please Enter Name";
                                      }
                                    },
                                    onfieldsumbitted: (value){
                                      FocusScope.of(context).requestFocus(desinationnode);
                                    },
                                  ),],
                              ),
                            ),
                          ),*/

                          SizedBox(height: 10),


                            SizedBox(width: 5,),
                            Text(
                              'DESIGNATION',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: primarycolor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            CommonTextForm(
                              fillColor: Colors.white,
                              labelColor: Colors.grey,
                              borderc: 5,
                              BorderColor:  Colors.grey,
                              symetric: true,

                              contentpadding: 5,
                              focusNode: desinationnode,
                              controller: designationController,
                              // heightTextform: height * 0.06,
                              labeltext: 'Designation',

                              icon: Icon(Icons.account_box,color: primarycolor,),
                             // icon:  Icon(
                              //   Icons.work,
                              //   color: primarycolor,
                              //   size: 20,
                              // ),
                              obsecureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please Enter Designation";
                                }
                              },
                              onfieldsumbitted: (value){
                                FocusScope.of(context).requestFocus(phonenode);
                              },

                            ),


                          SizedBox(height: 10),
                          // Phone
                          Text(
                            'PHONE NUMBERS',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     // Container(
                          //     //   width: 40,
                          //     //   height: 40,
                          //     //   decoration: BoxDecoration(
                          //     //     color: Colors.blue.withValues(alpha: 0.1),
                          //     //     borderRadius: BorderRadius.circular(8),
                          //     //   ),
                          //     //   child: Icon(
                          //     //     Icons.phone,
                          //     //     // color: Colors.blue[700],
                          //     //     color: primarycolor,
                          //     //     size: 20,
                          //     //   ),
                          //     // ),
                          //     SizedBox(width: 5,),
                          //
                          //   ],
                          // ),
                          SizedBox(height: 5),
                          CommonTextForm(
                            symetric: true,
                            fillColor: Colors.white,
                            labelColor:  Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 5,
                            focusNode: phonenode,
                            controller: phoneController,
                            // heightTextform: height * 0.06,
                            labeltext: 'Phone No',
                            icon: Icon(Icons.call_outlined,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter Mobile Number";
                              }
                            },
                            onfieldsumbitted: (value){
                              FocusScope.of(context).requestFocus(emailnode);
                            },
                          ),
                          SizedBox(height: 10),

                          // email
                          Text(
                            'EMAIL',
                            // style: GoogleFonts.inter(
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 14,
                            // ),

                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          CommonTextForm(
                            symetric: true,
                            fillColor: Colors.white,
                            labelColor:  Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 5,
                            focusNode: emailnode,
                            controller: emailController,
                            // heightTextform: height * 0.06,
                            labeltext: 'Email',
                            icon: Icon(Icons.email_outlined,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter email";
                              }
                            },
                            onfieldsumbitted: (value){
                              FocusScope.of(context).requestFocus(companynamenode);
                            },
                          ),
                          SizedBox(height: 10),

                          // Comapny Name
                          Text(
                            'COMPANY NAME',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          CommonTextForm(
                            symetric: true,
                            fillColor: Colors.white,
                            labelColor:  Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 5,
                            focusNode: companynamenode,
                            controller: companynameController,
                            // heightTextform: height * 0.06,
                            labeltext: 'Comapany Name',
                            icon: Icon(Icons.maps_home_work_outlined,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter CompanyName";
                              }
                            },
                            onfieldsumbitted: (value){
                              FocusScope.of(context).requestFocus(addressnode);
                            },
                          ),
                          SizedBox(height: 10),

                          // Address
                          Text(
                            'ADDRESS',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          CommonTextForm(
                            symetric: true,
                            fillColor: Colors.white,
                            labelColor:  Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 5,
                            focusNode: addressnode,
                            controller: addressController,
                            // heightTextform: height * 0.06,
                            labeltext: 'Address',
                            icon: Icon(Icons.location_pin,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter Address";
                              }
                            },
                            onfieldsumbitted: (value){
                              FocusScope.of(context).requestFocus(webnode
                              );
                            },
                          ),
                          SizedBox(height: 10),

                          // Company WebSite
                          Text(
                            'COMPANY WEBSITE',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          CommonTextForm(  symetric: true,
                            fillColor: Colors.white,
                            labelColor: Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 5,
                            focusNode: webnode,
                            controller: webController,
                            // heightTextform: height * 0.06,
                            labeltext: 'WebSite',
                            icon: Icon(Icons.web,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter Website";
                              }
                            },
                            onfieldsumbitted: (value){
                              FocusScope.of(context).requestFocus(notenode);
                            },
                          ),

                          SizedBox(height: 10),

                          // Note
                          Text(
                            'NOTE',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          CommonTextForm(
                            symetric: true,
                            fillColor: Colors.white,
                            labelColor:  Colors.grey,
                            borderc: 5,
                            BorderColor:  Colors.grey,
                            contentpadding: 10,
                            focusNode: notenode,
                            // contentpadding: 20,
                            controller: noteController,
                            maxline: 5,

                            heightTextform: height * 0.2,
                            labeltext: 'Notes',
                            icon: Icon(Icons.note_alt_outlined,color: primarycolor,),
                            obsecureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please Enter Note";
                              }
                            },
                          ),
                          SizedBox(height: 10),



                          Center(
                            child: CommonButton(
                              width: width * 0.8,
                              height: height * 0.06,
                              bordercircular: 5,
                              onTap: (){
                                if(_formkey.currentState!.validate()){
                                  _addcardtoHive();
                                }
                                // _addcardtoHive();
                                // _addData();
                              },
                              child: Text(
                                'Add Details',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),



            ],
          ),
        ),
      ),*/



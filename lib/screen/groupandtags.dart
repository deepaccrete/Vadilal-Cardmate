import 'dart:io';

import 'package:camera_app/api/GroupApi.dart';
import 'package:camera_app/api/TagApi.dart';
import 'package:camera_app/componets/button.dart';
import 'package:camera_app/componets/textform.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/model/GroupModel.dart';
import 'package:camera_app/model/TagModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';

class GroupAndTags extends StatefulWidget {
  const GroupAndTags({super.key});

  @override
  State<GroupAndTags> createState() => _GroupAndTagsState();
}

class _GroupAndTagsState extends State<GroupAndTags> {
  List<Data> groups = [];
  List<Datatag> tags = [];

  bool isGroupLoading = true;
  bool isTagLoading = true;
  String? errorMessage;
  String? errorMessageTag;

  // Future<bool> isInternetConnected() async {
  //   try {
  //     // Try to lookup google.com or any reliable host
  //     final result = await InternetAddress.lookup('google.com');
  //
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('Internet Available');
  //       return true;
  //     }
  //   } catch (e) {
  //     print('No Internet: $e');
  //   }
  //   return false;
  // }

  Future<void> fetchGroups() async {
    try {
      GroupModel groupModel = await GroupApi.getGroup();
      if (groupModel.success == 1 && groupModel.data != null) {
        setState(() {
          groups = groupModel.data!;
          isGroupLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "no Groups Found";
          isGroupLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong =>>>>>>>>>>> $e";
      });
    }
  }

  Future<void> fetchTag() async {
    isTagLoading = true;
    try {
      TagModel tagModel = await TagApi.getTag();
      if (tagModel.success == 1 && tagModel.data != null) {
        setState(() {
          tags = tagModel.data!;
          isTagLoading = false;
        });
      } else {
        setState(() {
          errorMessageTag = 'no tags found';
          isTagLoading = false;
        });
      }
    } catch (e) {
      errorMessageTag = "Something went Wrong => $e";
    } finally {
      setState(() {
        isTagLoading = false;
      });
    }
  }

  Future<void> Groupadd() async {
    try {
      if (_form.currentState!.validate()) {
        // Optional: show loading
        final groupPost = await GroupApi.postGroup(groupname: groupcontroller.text.trim());

        if (groupPost.success == 1) {
          print("GROUP ADDED");

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Group added successfully")));
          // groupcontroller.dispose();
          Navigator.pop(context);
          await fetchGroups(); // Refresh the group list
        } else {
          // Show actual message from server
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${groupPost.msg}Failed to add group")));
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  Future<void> TagAdd() async {
    try {
      if (_form.currentState!.validate()) {
        final tagpost = await TagApi.PostTag(tagname: tagcontroller.text.trim());

        if (tagpost.success == 1) {
          print("TAG ADDED ");
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tag Added Successfuly')));
          // tagcontroller.dispose();
          await fetchTag();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${tagpost.msg}Failed to Add Tag')));
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR $e")));
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // groupcontroller.dispose();
  // }
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGroups();
    fetchTag();
  }

  TextEditingController groupcontroller = TextEditingController();
  TextEditingController tagcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: screenBGColor,
      appBar: AppBar(
        centerTitle: true,
        // elevation: 10,
        backgroundColor: screenBGColor,
        // shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: (){
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Group & Tags',
          style: GoogleFonts.raleway(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/group-users 1.png', height: 50),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Groups',
                      style: GoogleFonts.raleway(color: primarycolor, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),

              // cards
              Row(
                children: [
                  // icon
                  if (appStore.appSetting?.isaddtag ?? false == true)
                    Expanded(
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: _form,
                                  child: AlertDialog(
                                    title: Text(
                                      'ADD GROUP',
                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: CommonTextForm(
                                      contentpadding: 5,
                                      controller: groupcontroller,
                                      borderc: 5,
                                      // labelColor: ,
                                      labeltext: 'Group Name',
                                      obsecureText: false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter GroupName";
                                        }
                                      },
                                    ),
                                    actions: [
                                      CommonButton(
                                        bordercircular: 5,
                                        height: height * 0.05,
                                        onTap: () {
                                          Groupadd();
                                        },
                                        child: Text(
                                          'Save',
                                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            width: width * 0.2,
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: Icon(Icons.group_add, color: Colors.grey, size: 40),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10),
                  // mycard
                  Expanded(
                    flex: 2,
                    child:
                        isGroupLoading
                            ? Container(
                              // color: Colors.red,
                              width: width * 0.3,
                              height: height * 0.15,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    child: groupshimmer(context),
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade200,
                                  );
                                },
                              ),
                            )
                            : Container(
                              width: width * 0.7,
                              height: height * 0.2,
                              // color: Colors.red,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  final group = groups[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      width: width * 0.25,
                                      // padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        // color: Colors.green,
                                        border: Border.all(width: 2, color: Colors.grey.shade100),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),

                                                  color: Colors.blue.shade100,
                                                  // shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  group.groupname![0],
                                                  style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: HexColor('#3259C2'),
                                                  ),
                                                ),
                                              ),

                                              Icon(Icons.more_vert_outlined, color: Colors.grey),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            group.groupname.toString(),
                                            style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                  ),
                ],
              ),

              // Tags
              Row(
                children: [
                  Image.asset('assets/images/price.png', height: 50),
                  SizedBox(width: 10),
                  Text(
                    'Tags',
                    style: GoogleFonts.raleway(color: primarycolor, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appStore.appSetting!.isaddtag ?? false == true)
                    Row(
                      children: [
                        Expanded(
                          flex: 0,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Form(
                                    key: _form,
                                    child: AlertDialog(
                                      title: Text(
                                        'ADD TAG',
                                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: CommonTextForm(
                                        contentpadding: 5,
                                        controller: tagcontroller,
                                        borderc: 5,
                                        // labelColor: ,
                                        labeltext: 'Tag Name',
                                        obsecureText: false,
                                        validator: (valuee) {
                                          if (valuee == null || valuee.isEmpty) {
                                            return "Please Enter Tag";
                                          }
                                        },
                                      ),
                                      actions: [
                                        CommonButton(
                                          bordercircular: 5,
                                          height: height * 0.05,
                                          onTap: () {
                                            TagAdd();
                                          },
                                          child: Text(
                                            'Save',
                                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 5,
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.black.withValues(alpha: 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(width: 1,)
                                ),
                                alignment: Alignment.center,
                                // color: Colors.red,
                                width: width * 0.2,
                                height: height * 0.07,
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  Expanded(
                    child: Container(
                      width: width * 0.3,
                      height: height * 0.07,
                      child:
                          isTagLoading
                              ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return Shimmer.fromColors(
                                    child: tagShimmer(context),
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade200,
                                  );
                                },
                              )
                              : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: tags.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final tag = tags[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: width * 0.25,
                                      height: height * 0.02,
                                      decoration: BoxDecoration(
                                        color: HexColor('E5E5E5'),
                                        // border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        tag.tagname.toString() ?? 'no name',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                ],
              ),
              // Network check
              // SizedBox(height: 10,),
              // CommonButton(
              //     width: width * 0.5,
              //     height:  height * 0.05,
              //     onTap: ()async{
              //
              //       bool  connected =  await isInternetConnected();
              //       if(connected){
              //         print('Connected');
              //       }else{
              //         print('Not Connected');
              //       }
              //
              //     },
              //     child:Text('Check Network',style: GoogleFonts.poppins(color: Colors.white),))
            ],
          ),
        ),
      ),
      // body: isLoading?
      //    Center(child: CircularProgressIndicator(),):
      //     ListView.builder(
      //         itemCount: groups.length,
      //         itemBuilder: (context , index){
      //           final group = groups[index];
      //           return ListTile(
      //             title: Text(group.groupname ?? 'unnamed Group'),
      //           subtitle: Text('Group ID : ${group.groupid}'),
      //           );
      //         })
      //
    );
  }

  Widget groupshimmer(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width * 0.25,
        // padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          // color: Colors.green,
          border: Border.all(width: 2, color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    color: Colors.blue.shade100,
                    // shape: BoxShape.circle,
                  ),
                  child: Text(
                    '',
                    style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 10, color: HexColor('#3259C2')),
                  ),
                ),

                Icon(Icons.more_vert_outlined, color: Colors.grey),
              ],
            ),

            SizedBox(height: 10),
            Text('', style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w700)),

            Text('', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget tagShimmer(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        width: width * 0.25,
        height: height * 0.02,
        decoration: BoxDecoration(
          color: HexColor('E5E5E5'),
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
        ),
      ),
    );
  }
}

import 'package:camera_app/api/GroupApi.dart';
import 'package:camera_app/api/TagApi.dart';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/model/GroupModel.dart';
import 'package:camera_app/model/TagModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

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


  Future <void> fetchTag()async{
    try{
      TagModel tagModel = await TagApi.getTag();
      if(tagModel.success == 1 && tagModel.data != null){
        setState(() {
          tags = tagModel.data!;
          isTagLoading = false;
        });
      }else{
        setState(() {
          errorMessageTag = 'no tags found';
          isTagLoading = false;
        });
      }
    }catch (e){
      errorMessageTag = "Something went Wrong => $e";
    }finally{
      setState(() {
        isTagLoading= false;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGroups();
    fetchTag();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: screenBGColor,
      appBar: AppBar(
        // elevation: 10,
        backgroundColor: screenBGColor,
        // shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        title: Text(
          'Group & Tags',
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
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
                      style: GoogleFonts.raleway(
                        color: primarycolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              // cards
              Row(
                children: [
                  // icon
                  Flexible(
                    fit: FlexFit.loose,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        width: width * 0.3,
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                        ),
                        child: Icon(
                          Icons.group_add,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  // mycard
                  Flexible(
                    fit: FlexFit.loose,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: width * 0.3,
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child:isGroupLoading
                        ?Center(child: CircularProgressIndicator())
                       : ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final group = groups[index];
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),

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

                                      Icon(
                                        Icons.more_vert_outlined,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),
                                  Text(
                                    group.groupname.toString(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  Text(
                                    group.groupid.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                    style: GoogleFonts.raleway(
                      color: primarycolor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                // color: Colors.grey,
                width: width,
                height: height *0.2,
                child:isTagLoading
                  ? Center(child: CircularProgressIndicator(),)

                :GridView.builder(
                  shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2
                        ,crossAxisSpacing: 10,
mainAxisExtent: 50,mainAxisSpacing: 5,

                        crossAxisCount: 3),
                  itemCount: tags.length,
                  itemBuilder: (BuildContext context, int index){
                      final tag = tags[index];
                      return
                        Container(
                          alignment: Alignment.center,
                          width: width * 0.25,
                          height: height * 0.02,
                          decoration: BoxDecoration(
                            color: HexColor('E5E5E5'),
                            // border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            tag.tagname.toString()?? 'no name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        );
                  },
                ),
              ),
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
}

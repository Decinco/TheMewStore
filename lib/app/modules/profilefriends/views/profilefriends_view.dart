import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themewstore/app/data/models/userData.dart';
import 'package:themewstore/uicon.dart';

import '../controllers/profilefriends_controller.dart';

class ProfilefriendsView extends GetView<ProfilefriendsController> {
  const ProfilefriendsView({super.key});

  Widget profileInfo(Future<UserData> userData) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              profilePicture(userData),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: Container(
                    width: 1, // Thickness
                    height: 110,
                    color: Color.fromRGBO(202, 196, 208, 1),
                  )),
              profileStats(userData)
            ],
          ),
          SizedBox(height: 10),
          profileDescription(userData)
        ]));
  }

  Widget profilePicture(Future<UserData> userData) {
    return Column(
      children: [
        Stack(
          children: [
            FutureBuilder(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 217, 217, 217),
                            highlightColor: Color.fromARGB(255, 255, 255, 255),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                              radius: 50,
                            )));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data found'));
                  } else {
                    UserData userData = snapshot.data!;
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData
                                  .profilePicture ??
                              'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                          radius: 50,
                        ));
                  }
                }),
            Positioned(
                right: 3,
                top: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    color: Color.fromRGBO(217, 217, 217, 1),
                    width: 30,
                    height: 30,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.changeImage();
                        },
                        icon: Icon(UIcons.fibspencil)),
                  ),
                ))
          ],
        ),
        FutureBuilder(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 217, 217, 217),
                    highlightColor: Color.fromARGB(255, 255, 255, 255),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 100,
                        height: 10,
                        color: Color.fromARGB(255, 217, 217, 217),
                      ),
                    ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data found');
              } else {
                UserData userData = snapshot.data!;
                return Text(
                  userData.userCode,
                  style: TextStyle(
                      color: Color.fromRGBO(152, 151, 151, 1),
                      fontSize: 12,
                      height: 0.8),
                );
              }
            }),
      ],
    );
  }

  Widget profileStats(Future<UserData> userData) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(width: 5),
            FutureBuilder(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 217, 217, 217),
                        highlightColor: Color.fromARGB(255, 255, 255, 255),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            width: 100,
                            height: 20,
                            color: Color.fromARGB(255, 217, 217, 217),
                          ),
                        ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data found');
                  } else {
                    UserData userData = snapshot.data!;
                    return Text(
                      userData.userName ?? 'No Name',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 0.1),
                    );
                  }
                }),
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Enter your username below:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextField(
                                  maxLength: 14,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  controller: controller.usernameC,
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    label: Text(
                                      "Username",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(152, 151, 151, 1)),
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                )),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                controller.changeUsername();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(135, 45),
                                elevation: 0,
                                backgroundColor:
                                    Color.fromARGB(255, 118, 171, 218),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Inter"),
                              ),
                              child: const Text("Submit"),
                            ),
                          ],
                        )),
                    isScrollControlled: true,
                    backgroundColor: Color.fromARGB(255, 237, 213, 229),
                    enterBottomSheetDuration: Duration(milliseconds: 150),
                  );
                },
                padding: EdgeInsets.only(left: 5),
                constraints: BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                icon: Icon(UIcons.fibspencil))
          ]),
          Padding(
              padding: EdgeInsets.only(left: 5),
              child: FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 100,
                              height: 12,
                              color: Color.fromARGB(255, 217, 217, 217),
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return Text(
                        userData.email,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1,
                            color: Color.fromRGBO(152, 151, 151, 1)),
                      );
                    }
                  })),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                UIcons.fibsglobe,
                size: 30,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              SizedBox(width: 5),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 100,
                              height: 16,
                              color: Color.fromARGB(255, 217, 217, 217),
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return Text(
                        userData.region,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                      );
                    }
                  }),
            ],
          ),
          Row(
            children: [
              Icon(
                UIcons.fibsmessagestar,
                size: 30,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              SizedBox(width: 2),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: StarRating(
                              size: 24,
                              color: Color.fromRGBO(78, 78, 78, 1),
                              borderColor: Color.fromRGBO(78, 78, 78, 1),
                              starCount: 5,
                              allowHalfRating: true,
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return StarRating(
                        size: 24,
                        rating: userData.rating.toDouble(),
                        color: Color.fromRGBO(78, 78, 78, 1),
                        borderColor: Color.fromRGBO(78, 78, 78, 1),
                        starCount: 5,
                        allowHalfRating: true,
                      );
                    }
                  })
            ],
          )
        ]);
  }

  Widget profileDescription(Future<UserData> userData) {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10,10,35,10),
                child: FutureBuilder(
                    future: userData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 217, 217, 217),
                            highlightColor: Color.fromARGB(255, 255, 255, 255),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                color: Color.fromARGB(255, 217, 217, 217),
                              ),
                            ));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data found');
                      } else {
                        UserData userData = snapshot.data!;
                        return Text(
                          '${userData.description != null ? '"${userData.description}"' : 'Make your own description!'}\n\n\n',
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color.fromRGBO(78, 78, 78, 1)),
                        );
                      }
                    })),
          )),
      Positioned(
          right: 3,
          top: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            child: Container(
              color: Color.fromRGBO(217, 217, 217, 1),
              width: 30,
              height: 30,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.bottomSheet(
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Enter your description below:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextField(
                                    maxLength: 150,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    maxLines: 4,
                                    controller: controller.descriptionC,
                                    decoration: const InputDecoration(
                                      label: Text(
                                        "Description",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                152, 151, 151, 1)),
                                      ),
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  )),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  controller.changeDescription();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(135, 45),
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 118, 171, 218),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: "Inter"),
                                ),
                                child: const Text("Submit"),
                              ),
                            ],
                          )),
                      isScrollControlled: true,
                      backgroundColor: Color.fromARGB(255, 237, 213, 229),
                      enterBottomSheetDuration: Duration(milliseconds: 150),
                    );
                  },
                  icon: Icon(UIcons.fibspencil)),
            ),
          ))
    ]);
    // TextField(
    //   maxLines: 4,
    //   controller: controller.descriptionC,
    //   decoration: const InputDecoration(
    //     alignLabelWithHint: true,
    //     floatingLabelBehavior: FloatingLabelBehavior.never,
    //     label: Text(
    //       "Description",
    //       style: TextStyle(color: Color.fromRGBO(152, 151, 151, 1)),
    //     ),
    //     border: InputBorder.none,
    //     fillColor: Colors.white,
    //     filled: true,
    //   ),
    // )
  }

  @override
  Widget build(BuildContext context) {
    controller.userData = controller.getProfileData().obs;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile & Friends',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              )),
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          centerTitle: true,
        ),
        body: Container(
            color: Color.fromARGB(255, 237, 213, 229),
            width: double.infinity,
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: "Profile",
                        icon: Icon(UIcons.fibsuser),
                      ),
                      Tab(
                        text: "Friends",
                        icon: Icon(UIcons.fibsusers),
                      )
                    ],
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Inter"),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    Obx(() => Column(
                          children: [
                            profileInfo(controller.userData.value),
                            // Add more widgets here as needed
                          ],
                        )),
                    Container()
                  ]))
                ]))));
  }
}

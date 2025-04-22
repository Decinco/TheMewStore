import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:themewstore/app/data/models/userData.dart';
import 'package:themewstore/uicon.dart';

import '../controllers/profilefriends_controller.dart';

class ProfilefriendsView extends GetView<ProfilefriendsController> {
  const ProfilefriendsView({super.key});

  Widget profileInfo(UserData userData) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData
                                    .profilePicture ??
                                'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                            radius: 50,
                          )),
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
                                    Get.snackbar(
                                        "cambiar Imagen", "TODO"); // TODO
                                  },
                                  icon: Icon(UIcons.fibspencil)),
                            ),
                          ))
                    ],
                  ),
                  Text(
                    userData.userCode,
                    style: TextStyle(
                        color: Color.fromRGBO(152, 151, 151, 1),
                        fontSize: 12,
                        height: 0.8),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: Container(
                    width: 1, // Thickness
                    height: 110,
                    color: Color.fromRGBO(202, 196, 208, 1),
                  )),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SizedBox(width: 5),
                      Text(
                        userData.userName ?? 'No Name',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 0.1),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.snackbar("change username", "TODO"); // TODO
                          },
                          padding: EdgeInsets.only(left: 5),
                          constraints: BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // the '2023' part
                          ),
                          icon: Icon(UIcons.fibspencil))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          userData.email,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1,
                              color: Color.fromRGBO(152, 151, 151, 1)),
                        )),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          UIcons.fibsglobe,
                          size: 30,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                        SizedBox(width: 5),
                        Text(
                          userData.region,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(78, 78, 78, 1),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          UIcons.fibsmessagestar,
                          size: 30,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                        SizedBox(width: 5),
                        StarRating()
                      ],
                    )
                  ])
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                maxLines: 4,
                controller: controller.descriptionC,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    "Add your own description!",
                    style: TextStyle(color: Color.fromRGBO(152, 151, 151, 1)),
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
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
                    FutureBuilder(
                        future: controller.getProfileData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('No data found'));
                          } else {
                            UserData userData = snapshot.data!;

                            return Column(
                              children: [
                                profileInfo(userData),
                                // Add more widgets here as needed
                              ],
                            );
                          }
                        }),
                    Container()
                  ]))
                ]))));
  }
}

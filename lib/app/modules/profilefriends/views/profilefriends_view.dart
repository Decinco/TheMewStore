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
        child: Row(
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
                                  Get.snackbar("cambiar Imagen", "TODO");
                                },
                                icon: Icon(UIcons.fibspencil)),
                          ),
                        ))
                  ],
                ),
                Text(
                  userData.userCode,
                  style: TextStyle(
                      color: Color.fromRGBO(152, 151, 151, 1), fontSize: 12),
                ),
              ],
            ),
            Divider(
              height: 80,
              thickness: 15,
              indent: 10,
              endIndent: 10,
              color: Color.fromRGBO(152, 151, 151, 1),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.userName ?? 'No Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(userData.email),
                ])
          ],
        ));
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

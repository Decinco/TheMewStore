import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:themewstore/app/data/models/userData.dart';

import '../controllers/profilefriends_controller.dart';

class ProfilefriendsView extends GetView<ProfilefriendsController> {
  const ProfilefriendsView({super.key});

  Widget profileInfo(UserData userData) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(userData.profilePicture ??
              'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
          radius: 50,
        ),
        Text(userData.userName ?? 'No Name'),
        Text(userData.email),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile & Friends',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromARGB(255, 237, 213, 229),
          width: double.infinity,
          child: FutureBuilder(
              future: controller.getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
        ));
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profilefriends_controller.dart';

class ProfilefriendsView extends GetView<ProfilefriendsController> {
  const ProfilefriendsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfilefriendsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfilefriendsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

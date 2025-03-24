import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/userData.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Future<UserData> userData = controller.getUserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<UserData>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed("/login");
                          },
                          child: Text("Return"))
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Username: ${snapshot.data?.userName}'),
                      Text('Email: ${snapshot.data?.email}'),
                      Text('Region: ${snapshot.data?.region}'),
                      Text('Description: ${snapshot.data?.description}'),
                      Text('Rating: ${snapshot.data!.rating}'),
                      Text('UserCode: ${snapshot.data!.userCode}'),
                      ElevatedButton(
                          onPressed: () {
                            controller.logOut();
                          },
                          child: Text("Log Out"))
                    ],
                  );
                }
              }
            }),
      ),
    );
  }
}

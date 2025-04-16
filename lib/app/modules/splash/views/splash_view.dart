import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 237, 213, 229),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 213, 229),
        body: Center(
          child: Image.asset(
            'assets/images/themewstore/themewstore.png',
          ),
        ),
      ),
    );
  }
}

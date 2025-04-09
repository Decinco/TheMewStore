import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  const PasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

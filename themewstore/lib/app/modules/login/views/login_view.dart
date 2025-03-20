import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../uicon.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        color: Color.fromARGB(255, 237, 213, 229),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                SizedBox(
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/home");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            UIcons.fibsuseradd,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Image(
                        image: AssetImage(
                            "assets/images/themewstore/themewstore.png"),
                        height: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: controller.emailC,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        label: Text("Email"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: controller.passwordC,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        label: Text("Password"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                bool? login = await controller.loginGoogle();
                                if (login == true) {
                                  Get.toNamed("/home");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                fixedSize: Size(135, 45),
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              child: Row(
                                children: [
                                  const Image(
                                      image: AssetImage(
                                          "assets/images/google/googl.png"),
                                      fit: BoxFit.cover),
                                  Flexible(
                                    child: const Text("Sign in with Google",
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                  )
                                ],
                              )),
                          SizedBox.fromSize(
                            size: Size(10, 10),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool? login = await controller.login();
                              if (login == true) {
                                Get.toNamed("/home");
                              }
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
                            child: const Text("Log In"),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/home");
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:themewstore/app/modules/signup/controllers/signup_controller.dart';

import '../../../../uicon.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

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
                  size: Size(0, 45),
                ),
                SizedBox(
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Get.offAllNamed("/login");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            UIcons.fibsuserkey,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child: Text(
                        "Sign Up",
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
                      controller: controller.usernameC,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        label: Text("Username"),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: controller.passwordAgainC,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        label: Text("Confirm Password"),
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
                                controller.loginGoogle();
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
                                    child: const Text("Sign up with Google",
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
                              bool? signup = await controller.signup();
                              if (signup == true) {
                                Get.offAllNamed("/login");
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
                            child: const Text("Sign Up"),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:themewstore/generated/locales.g.dart';
import '../controllers/password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  const PasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.emailC.text = Get.arguments;
    final FocusNode otpFocusNode = FocusNode();
    final FocusNode firstPasswordFocusNode = FocusNode();
    bool isProcessing = false;

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          title: Text(LocaleKeys.signIn_passwordReset.tr,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Container(
            color: Color.fromARGB(255, 237, 213, 229),
            child: DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: Builder(builder: (context) {
                  return Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          LocaleKeys.signIn_passwordResetInstructions_email.tr,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: TextField(
                                          controller: controller.emailC,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.white,
                                            filled: true,
                                            label: Text(LocaleKeys.signIn_email.tr),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ElevatedButton(
                                        onPressed: isProcessing
                                            ? null
                                            : () async {
                                                isProcessing = true;

                                                bool? result =
                                                    await controller.sendOtp();
                                                if (result == true) {
                                                  if (context.mounted) {
                                                    otpFocusNode.requestFocus();
                                                    DefaultTabController.of(
                                                            context)
                                                        .animateTo(1);
                                                  }
                                                }

                                                isProcessing = false;
                                              },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(135, 45),
                                          elevation: 0,
                                          backgroundColor: Color.fromARGB(
                                              255, 118, 171, 218),
                                          foregroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              fontFamily: "Inter"),
                                        ),
                                        child: Text(LocaleKeys.signIn_send.tr),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          LocaleKeys.signIn_passwordResetInstructions_code.tr,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      PinCodeTextField(
                                        focusNode: otpFocusNode,
                                        enableActiveFill: true,
                                        controller: controller.codeC,
                                        appContext: context,
                                        length: 6,
                                        cursorColor: Colors.black,
                                        animationType: AnimationType.fade,
                                        keyboardType: TextInputType.number,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          fieldHeight: 55,
                                          fieldWidth: 50,
                                          activeFillColor: Colors.white,
                                          inactiveFillColor: Colors.white,
                                          selectedFillColor: Colors.white,
                                          selectedColor: Colors.white,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: isProcessing
                                            ? null
                                            : () async {
                                                isProcessing = true;

                                                bool? result = await controller
                                                    .verifyOtp();
                                                if (result == true) {
                                                  if (context.mounted) {
                                                    firstPasswordFocusNode
                                                        .requestFocus();
                                                    DefaultTabController.of(
                                                            context)
                                                        .animateTo(2);
                                                  }
                                                }

                                                isProcessing = false;
                                              },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(135, 45),
                                          elevation: 0,
                                          backgroundColor: Color.fromARGB(
                                              255, 118, 171, 218),
                                          foregroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              fontFamily: "Inter"),
                                        ),
                                        child: Text(LocaleKeys.signIn_send.tr),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          LocaleKeys.signIn_passwordResetInstructions_newPassword.tr,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: TextField(
                                          focusNode: firstPasswordFocusNode,
                                          controller: controller.nuPasswordC,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.white,
                                            filled: true,
                                            label: Text(LocaleKeys.signIn_password.tr),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: TextField(
                                          controller:
                                              controller.nuPasswordConfirmC,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.white,
                                            filled: true,
                                            label: Text(LocaleKeys.signIn_confirmPassword.tr),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ElevatedButton(
                                        onPressed: isProcessing
                                            ? null
                                            : () async {
                                                isProcessing = true;

                                                controller.changePassword();

                                                isProcessing = false;
                                              },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(135, 45),
                                          elevation: 0,
                                          backgroundColor: Color.fromARGB(
                                              255, 118, 171, 218),
                                          foregroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              fontFamily: "Inter"),
                                        ),
                                        child: Text(LocaleKeys.signIn_reset.tr),
                                      ),
                                    ],
                                  )),
                            ]),
                      )
                    ],
                  );
                }))));
  }
}

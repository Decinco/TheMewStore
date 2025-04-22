import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/utils/googleLogIn.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  SupabaseClient client = Supabase.instance.client;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  onClose() {
    emailC.text = "";
    passwordC.text = "";
    super.onClose();
  }

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        AuthResponse res = await client.auth
            .signInWithPassword(email: emailC.text, password: passwordC.text);
        isLoading.value = false;

        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Oops!", e.toString());
      }
    } else {
      Get.snackbar("Wrong!", "Email and password are required");
    }
    return null;
  }

  Future<bool?> loginGoogle() async {
    try {
      await GoogleLoginUtils.nativeGoogleSignIn(client);
      return true;
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
    return null;
  }
}

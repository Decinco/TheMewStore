import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/googleLogIn.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  SupabaseClient client = Supabase.instance.client;
  TextEditingController emailC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordAgainC = TextEditingController();

  @override
  onClose() {
    emailC.dispose();
    usernameC.dispose();
    passwordC.dispose();
    passwordAgainC.dispose();
    super.onClose();
  }

  Future<bool?> signup() async {
    if (emailC.text.isEmpty ||
        passwordC.text.isEmpty ||
        usernameC.text.isEmpty ||
        passwordAgainC.text.isEmpty) {
      Get.snackbar("Wrong!", "All fields are required");
    } else if (passwordC.text != passwordAgainC.text) {
      Get.snackbar("Wrong!", "Passwords do not match");
    } else if (passwordC.text.length < 8) {
      Get.snackbar("Wrong!", "Password must be at least 8 characters");
    } else if (usernameC.text.length < 3) {
      Get.snackbar("Wrong!", "Username must be at least 3 characters");
    } else if (passwordC.text.contains(RegExp("[A-Z]")) == false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one uppercase letter");
    } else if (passwordC.text.contains(RegExp("[a-z]")) == false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one lowercase letter");
    } else if (passwordC.text.contains(RegExp("[0-9]")) == false) {
      Get.snackbar("Wrong!", "Password must contain at least one number");
    } else if (passwordC.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-_]')) ==
        false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one special character");
    } else {
      isLoading.value = true;
      try {
        await client.auth.signUp(
            email: emailC.text,
            password: passwordC.text,
            data: {"name": usernameC.text});
        isLoading.value = false;
        Get.snackbar(
            "Success!", "You will need to confirm your email to log in");
        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Oops!", e.toString());
      }
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

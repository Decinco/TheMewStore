import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  TextEditingController emailC = TextEditingController();
  TextEditingController codeC = TextEditingController();
  TextEditingController nuPasswordC = TextEditingController();
  TextEditingController nuPasswordConfirmC = TextEditingController();

  Future<bool?> sendOtp() async {
    if (emailC.text.isNotEmpty) {
      try {
        await client.auth.signInWithOtp(
          email: emailC.text,
          shouldCreateUser: false,
        );
        return true;
      } catch (e) {
        Get.snackbar("Oops!", e.toString());
      }
    } else {
      Get.snackbar("Wrong!", "Email is required");
    }
    return null;
  }

  Future<bool?> verifyOtp() async {
    if (emailC.text.isNotEmpty && codeC.text.isNotEmpty) {
      try {
        await client.auth.verifyOTP(
          type: OtpType.magiclink,
          email: emailC.text,
          token: codeC.text,
        );
        return true;
      } catch (e) {
        Get.snackbar("Oops!", e.toString());
        codeC.text = "";
      }
    } else {
      Get.snackbar("Wrong!", "Code is required!");
    }
    return null;
  }

  Future<bool?> changePassword() async {
    if (nuPasswordC.text.isEmpty || nuPasswordConfirmC.text.isEmpty) {
      Get.snackbar("Wrong!", "All fields are required");
    } else if (nuPasswordC.text != nuPasswordConfirmC.text) {
      Get.snackbar("Wrong!", "Passwords do not match");
    } else if (nuPasswordC.text.length < 8) {
      Get.snackbar("Wrong!", "Password must be at least 8 characters");
    } else if (nuPasswordC.text.length < 3) {
      Get.snackbar("Wrong!", "Username must be at least 3 characters");
    } else if (nuPasswordC.text.contains(RegExp("[A-Z]")) == false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one uppercase letter");
    } else if (nuPasswordC.text.contains(RegExp("[a-z]")) == false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one lowercase letter");
    } else if (nuPasswordC.text.contains(RegExp("[0-9]")) == false) {
      Get.snackbar("Wrong!", "Password must contain at least one number");
    } else if (nuPasswordC.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-_]')) ==
        false) {
      Get.snackbar(
          "Wrong!", "Password must contain at least one special character");
    } else {
      try {
        await client.auth.updateUser(
          UserAttributes(password: nuPasswordC.text),
        );
        await client.auth.signOut(
          scope: SignOutScope.global,
        );
        Get.snackbar("Success!", "Password has been updated successfully");
        return true;
      } catch (e) {
        Get.snackbar("Oops!", e.toString());
      }
    }
    return null;
  }
}

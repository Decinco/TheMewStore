import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../generated/locales.g.dart';

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
        Get.snackbar(LocaleKeys.errors_title_serverError.tr, e.toString());
      }
    } else {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_emailRequired.tr);
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
        Get.snackbar(LocaleKeys.errors_title_serverError.tr, e.toString());
        codeC.text = "";
      }
    } else {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_codeRequired.tr);
    }
    return null;
  }

  Future<bool?> changePassword() async {
    if (nuPasswordC.text.isEmpty ||
        nuPasswordConfirmC.text.isEmpty) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_fieldsEmpty.tr);
    } else if (nuPasswordC.text != nuPasswordConfirmC.text) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_doNotMatch.tr);
    } else if (nuPasswordC.text.length < 8) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_tooShort.tr);
    } else if (nuPasswordC.text.length < 3) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_username_tooShort.tr);
    } else if (nuPasswordC.text.contains(RegExp("[A-Z]")) == false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noUppercase.tr);
    } else if (nuPasswordC.text.contains(RegExp("[a-z]")) == false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noLowercase.tr);
    } else if (nuPasswordC.text.contains(RegExp("[0-9]")) == false) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noNumber.tr);
    } else if (nuPasswordC.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-_]')) ==
        false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noSpecialChar.tr);
    } else {
      try {
        await client.auth.updateUser(
          UserAttributes(password: nuPasswordC.text),
        );
        await client.auth.signOut(
          scope: SignOutScope.global,
        );
        Get.snackbar(LocaleKeys.notifs_passwordReset_title.tr, LocaleKeys.notifs_passwordReset_message.tr);
        return true;
      } catch (e) {
        Get.snackbar(LocaleKeys.errors_title_serverError.tr, e.toString());
      }
    }
    return null;
  }
}

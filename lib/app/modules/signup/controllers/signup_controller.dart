import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../generated/locales.g.dart';
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
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_fieldsEmpty.tr);
    } else if (passwordC.text != passwordAgainC.text) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_doNotMatch.tr);
    } else if (passwordC.text.length < 8) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_tooShort.tr);
    } else if (usernameC.text.length < 3) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_username_tooShort.tr);
    } else if (passwordC.text.contains(RegExp("[A-Z]")) == false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noUppercase.tr);
    } else if (passwordC.text.contains(RegExp("[a-z]")) == false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noLowercase.tr);
    } else if (passwordC.text.contains(RegExp("[0-9]")) == false) {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noNumber.tr);
    } else if (passwordC.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-_]')) ==
        false) {
      Get.snackbar(
          LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_password_noSpecialChar.tr);
    } else {
      isLoading.value = true;
      try {
        await client.auth.signUp(
            email: emailC.text,
            password: passwordC.text,
            data: {"name": usernameC.text});
        isLoading.value = false;
        Get.snackbar(
            LocaleKeys.notifs_emailVerification_title.tr, LocaleKeys.notifs_emailVerification_message.tr);
        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(LocaleKeys.errors_title_serverError.tr, e.toString());
      }
    }
    return null;
  }

  Future<bool?> loginGoogle() async {
    try {
      await GoogleLoginUtils.nativeGoogleSignIn(client);
      return true;
    } catch (e) {
      Get.snackbar(LocaleKeys.errors_title_serverError.tr, e.toString());
    }
    return null;
  }
}

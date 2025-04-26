import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/userData.dart';

class ForeignprofileController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  User user = Supabase.instance.client.auth.currentUser!;

  TextEditingController descriptionC = TextEditingController();
  TextEditingController usernameC = TextEditingController();

  late Rx<Future<UserData>> userData;

  Future<UserData> getProfileData() async {
    final response =
    await client.from('user_data').select().eq('user_id', user.id).single();

    UserData userData = UserData.fromJson(response);

    descriptionC.text = userData.description ?? "";
    usernameC.text = userData.userName ?? "";

    return userData;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/data/models/userData.dart';

class ProfilefriendsController extends GetxController {
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

  Future<void> changeUsername() async {;
    UserData data = await userData.value;
    if (usernameC.text != data.userName) {
      await client.from('user_data').update({"user_name": usernameC.text}).eq(
          "user_id", user.id);

      userData.value = getProfileData();

      userData.refresh();
    }
  }

  Future<void> changeImage() async {
    
  }
}

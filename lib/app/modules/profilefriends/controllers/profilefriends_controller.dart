import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/data/models/userData.dart';

import '../../../data/models/card.dart';
import '../../../data/models/expansion.dart';

class ProfilefriendsController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  User user = Supabase.instance.client.auth.currentUser!;

  TextEditingController descriptionC = TextEditingController();
  TextEditingController usernameC = TextEditingController();

  late Rx<Future<UserData>> userData;
  late Rx<Future<List<Card>>> albumData;
  late Future<List<Expansion>> expansionData;

  Future<UserData> getProfileData() async {
    final response =
        await client.from('user_data').select().eq('user_id', user.id).single();

    UserData userData = UserData.fromJson(response);

    descriptionC.text = userData.description ?? "";
    usernameC.text = userData.userName ?? "";

    return userData;
  }

  Future<List<Card>> getAlbumData() async {
    final response =
        await client.from('album').select('card(*)').eq('user_id', user.id);

    List<Card> albumData = [];

    for (var item in response) {
      albumData.add(Card.fromJson(item['card']));
    }

    return albumData;
  }

  Future<Expansion> getExpansionData(Card cardData) async {
    final response = await client.from('expansion').select('*').eq('expansion_id', cardData.expansionId).single();

    Expansion expansion = Expansion.fromJson(response);

    return expansion;
  }

  Future<List<Expansion>> getAllExpansions() async {
    final response = await client.from('expansion').select('*');

    List<Expansion> expansionData = [];

    for (var item in response) {
      expansionData.add(Expansion.fromJson(item));
    }

    return expansionData;
  }

  Future<void> changeUsername() async {;
    UserData data = await userData.value;
    if (usernameC.text != data.userName) {
      if (usernameC.text.isEmpty) {
        Get.snackbar("Wrong!", "Username cannot be empty");
      }
      else if (usernameC.text.length < 3) {
        Get.snackbar("Wrong!", "Username must be at least 3 characters");
      }
      else  {
        await client.from('user_data').update({"user_name": usernameC.text}).eq(
            "user_id", user.id);

        userData.value = getProfileData();

        userData.refresh();
      }
    }
  }

  Future<void> changeDescription() async {;
  UserData data = await userData.value;
  if (descriptionC.text != data.description) {
    if (usernameC.text.isEmpty) {
      await client.from('user_data')
          .update({"description": null})
          .eq(
          "user_id", user.id);
    }
    else {
      await client.from('user_data')
          .update({"description": descriptionC.text})
          .eq(
          "user_id", user.id);
    }

    userData.value = getProfileData();

    userData.refresh();
  }
  }

  Future<void> changeImage() async {
    UserData data = await userData.value;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
    );

    final String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    await client.storage.from('profilepictures').upload(
      'saved/user/${data.userId}/$imageName.png',
      File(image!.path),
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    final String link = await client.storage.from('profilepictures').getPublicUrl('saved/user/${data.userId}/$imageName.png');

    await client.from('user_data').update({"profile_picture": link}).eq(
        "user_id", user.id);

    userData.value = getProfileData();

    userData.refresh();
  }
}

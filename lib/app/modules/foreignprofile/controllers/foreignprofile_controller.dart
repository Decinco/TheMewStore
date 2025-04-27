import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/card.dart';
import '../../../data/models/expansion.dart';
import '../../../data/models/userData.dart';

class ForeignprofileController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  User user = Supabase.instance.client.auth.currentUser!;

  TextEditingController descriptionC = TextEditingController();
  TextEditingController usernameC = TextEditingController();

  late Rx<Future<UserData>> userData;
  late Rx<Future<List<Expansion>>> expansionData; // 👈 Añadido esto

  @override
  void onInit() {
    super.onInit();
    expansionData = getAllExpansions().obs;
  }

  Future<UserData> getProfileData() async {
    final response =
    await client.from('user_data').select().eq('user_id', user.id).single();
    UserData userData = UserData.fromJson(response);
    descriptionC.text = userData.description ?? "";
    usernameC.text = userData.userName ?? "";
    return userData;
  }

  Future<Expansion> getExpansionData(Card cardData) async {
    final response = await client.from('expansion').select('*').eq('expansion_id', cardData.expansionId).single();
    Expansion expansion = Expansion.fromJson(response);
    return expansion;
  }

  Future<List<Card>> getAlbumData(String uuid) async {
    final response = await client.from('album').select('card(*)').eq('user_id', uuid);
    List<Card> albumData = [];
    for (var item in response) {
      albumData.add(Card.fromJson(item['card']));
    }
    return albumData;
  }

  Future<List<Expansion>> getAllExpansions() async {
    final response = await client.from('expansion').select('*');
    List<Expansion> expansionData = [];
    for (var item in response) {
      expansionData.add(Expansion.fromJson(item));
    }
    return expansionData;
  }
}


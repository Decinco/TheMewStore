import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/card.dart';
import '../../../data/models/expansion.dart';
import '../../../data/models/userData.dart';

class ForeignprofileController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  final String uuid; // UUID del amigo

  ForeignprofileController(this.uuid); // Constructor que recibe el UUID

  late Rx<Future<UserData>> friendData;
  late Rx<Future<List<Expansion>>> expansionData;
  late Rx<Future<List<Card>>> albumData;

  @override
  void onInit() {
    super.onInit();
    friendData = getFriendData(uuid).obs;
    expansionData = getAllExpansions().obs;
    albumData = getAlbumData(uuid).obs;
  }

  Future<UserData> getFriendData(String friendUuid) async {
    final response = await client
        .from('user_data')
        .select()
        .eq('user_id', friendUuid)
        .single();
    return UserData.fromJson(response);
  }

  Future<Expansion> getExpansionData(Card cardData) async {
    final response = await client
        .from('expansion')
        .select('*')
        .eq('expansion_id', cardData.expansionId)
        .single();
    return Expansion.fromJson(response);
  }

  Future<List<Card>> getAlbumData(String friendUuid) async {
    final response = await client
        .from('album')
        .select('card(*)')
        .eq('user_id', friendUuid);

    if (response.isEmpty) return [];

    return response.map<Card>((item) => Card.fromJson(item['card'])).toList();
  }

  Future<List<Expansion>> getAllExpansions() async {
    final response = await client.from('expansion').select('*');
    return response.map<Expansion>((item) => Expansion.fromJson(item)).toList();
  }
}
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/album.dart';
import '../../../data/models/card.dart';
import '../../../data/models/expansion.dart';
import '../../../data/models/userData.dart';

class ForeignprofileController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  final String uuid; // UUID del amigo

  ForeignprofileController(this.uuid); // Constructor que recibe el UUID

  late Future<UserData> friendData;
  late Future<List<Album>> albumData;

  @override
  void onInit() {
    super.onInit();
    friendData = getFriendData(uuid);
    albumData = getAlbumData(uuid);
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

  Future<List<Album>> getAlbumData(String friendUuid) async {
    final response =
    await client.from('album').select('*').eq('user_id', friendUuid);

    List<Album> albumData = [];

    for (var item in response) {
      albumData.add(Album.fromJson(item));
    }

    return albumData;
  }

  Future<Card> getAlbumCardData(int cardId) async {
    final response =
    await client.from('card').select('*').eq('card_id', cardId).single();

    Card card = Card.fromJson(response);

    return card;
  }
}
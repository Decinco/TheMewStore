import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/data/models/friendLink.dart';
import 'package:themewstore/app/data/models/userData.dart';
import 'package:themewstore/generated/locales.g.dart';

import '../../../data/models/album.dart';
import '../../../data/models/card.dart';
import '../../../data/models/expansion.dart';

class ProfilefriendsController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  User user = Supabase.instance.client.auth.currentUser!;

  TextEditingController descriptionC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController expansionCodeC = TextEditingController();
  TextEditingController cardNoC = TextEditingController();
  TextEditingController printedTotalC = TextEditingController();

  RxBool editMode = false.obs;

  late Rx<Future<UserData>> userData;
  late Rx<Future<List<Album>>> albumData;
  late Future<List<Expansion>> expansionData;
  late Rx<Future<List<FriendLink>>> friendList;

  Future<UserData> getProfileData() async {
    final response =
        await client.from('user_data').select().eq('user_id', user.id).single();

    UserData userData = UserData.fromJson(response);

    descriptionC.text = userData.description ?? "";
    usernameC.text = userData.userName ?? "";

    return userData;
  }

  Future<List<Album>> getAlbumData() async {
    final response =
        await client.from('album').select('*').eq('user_id', user.id);

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

  Future<Expansion> getExpansionData(Card cardData) async {
    final response = await client
        .from('expansion')
        .select('*')
        .eq('expansion_id', cardData.expansionId)
        .single();

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

  Future<void> changeUsername() async {
    ;
    UserData data = await userData.value;
    if (usernameC.text != data.userName) {
      if (usernameC.text.isEmpty) {
        Get.snackbar("Wrong!", "Username cannot be empty");
      } else if (usernameC.text.length < 3) {
        Get.snackbar("Wrong!", "Username must be at least 3 characters");
      } else {
        await client
            .from('user_data')
            .update({"user_name": usernameC.text}).eq("user_id", user.id);

        userData.value = getProfileData();

        userData.refresh();
      }
    }
  }

  Future<void> changeDescription() async {
    ;
    UserData data = await userData.value;
    if (descriptionC.text != data.description) {
      if (usernameC.text.isEmpty) {
        await client
            .from('user_data')
            .update({"description": null}).eq("user_id", user.id);
      } else {
        await client
            .from('user_data')
            .update({"description": descriptionC.text}).eq("user_id", user.id);
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

    final String link = await client.storage
        .from('profilepictures')
        .getPublicUrl('saved/user/${data.userId}/$imageName.png');

    await client
        .from('user_data')
        .update({"profile_picture": link}).eq("user_id", user.id);

    userData.value = getProfileData();

    userData.refresh();
  }

  Future<List<FriendLink>> getFriends() async {
    final response = await client
        .from('friends')
        .select()
        .neq('status', 'Canceled')
        .or('user_id.eq."${user.id}",friend_id.eq."${user.id}"')
        .order("last_interaction", ascending: false);

    List<FriendLink> friendLink = [];

    for (var item in response) {
      friendLink.add(FriendLink.fromJson(item));
    }

    return friendLink;
  }

  void subscribeToFriendChanges() {
    client
        .channel("friendsUserId")
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'friends',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: user.id),
            callback: (PostgresChangePayload payload) {
              friendList.value = getFriends();
              friendList.refresh();
            })
        .subscribe();

    client
        .channel("friendsFriendId")
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'friends',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'friend_id',
                value: user.id),
            callback: (PostgresChangePayload payload) {
              friendList.value = getFriends();
              friendList.refresh();
            })
        .subscribe();
  }

  Future<UserData> getFriendData(String friendId) async {
    final response = await client
        .from('user_data')
        .select()
        .eq('user_id', friendId)
        .single();

    UserData userData = UserData.fromJson(response);

    return userData;
  }

  Future<void> deleteFriend(String userId, String friendId) async {
    await client
        .from('friends')
        .update({"status": "Canceled"})
        .eq('friend_id', friendId)
        .eq('user_id', userId);
  }

  Future<void> acceptFriend(String friendId) async {
    await client
        .from('friends')
        .update({"status": "Linked"})
        .eq('friend_id', user.id)
        .eq('user_id', friendId);
  }

  Future<void> cancelFriend(String friendId) async {
    await client
        .from('friends')
        .update({"status": "Canceled"})
        .eq('friend_id', user.id)
        .eq('user_id', friendId);
  }

  Future<void> deleteCard(int albumCardId) async {
    await client.from('album').delete().eq('album_card_id', albumCardId);

    albumData.value = getAlbumData();

    albumData.refresh();
  }

  Future<void> addCard() async {
    if (cardNoC.text.isEmpty ||
        printedTotalC.text.isEmpty ||
        expansionCodeC.text.isEmpty) {
      Get.back();
      Get.snackbar(LocaleKeys.errors_title_userError.tr,
          LocaleKeys.errors_description_fieldsEmpty.tr);
    } else {
      var response = await client
          .from('card')
          .select('*,expansion!inner(*)')
          .eq('expansion.expansion_code', expansionCodeC.text.toUpperCase())
          .eq('expansion.printed_total', printedTotalC.text)
          .eq('number_in_expansion', cardNoC.text);
      if (response.isEmpty) {
        Get.back();

        Get.snackbar(LocaleKeys.errors_title_userError.tr,
            LocaleKeys.errors_description_cardNotFound.tr);
      } else {
        Card card = Card.fromJson(response[0]);

        await client.from('album').insert({
          "user_id": user.id,
          "card_id": card.cardId
        });

        cardNoC.text = "";
        printedTotalC.text = "";
        expansionCodeC.text = "";

        Get.back();

        albumData.value = getAlbumData();

        albumData.refresh();
      }

      albumData.value = getAlbumData();

      albumData.refresh();
    }
  }

  @override
  void onClose() async {
    super.onClose();
  }
}

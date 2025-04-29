import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/generated/locales.g.dart';

import '../../../data/models/friendLink.dart';

class FriendNotificationController extends GetxController {
  RxBool loggedIn = false.obs;
  SupabaseClient client = Supabase.instance.client;

  late String firstpage;

  @override
  void onInit() async {
    await dotenv.load(fileName: ".env");
    firstpage = dotenv.env['DEFAULT_FIRST_PAGE'] ?? '/home';

    super.onInit();
    subscribeToNotifs();
  }

  void subscribeToNotifs() {
    client.channel("globalNotifications")
        .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'friends',
        filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'friend_id',
            value: client.auth.currentUser!.id),
        callback: (PostgresChangePayload payload) {
          FriendLink friendLink = FriendLink.fromJson(payload.newRecord);
          if (friendLink.status == Status.Pending) {
            Get.snackbar(LocaleKeys.notifs_newFriendRequest_title.tr, LocaleKeys.notifs_newFriendRequest_message.tr);
          }
        })
        .subscribe();
  }
}

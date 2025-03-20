import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/userData.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  late Rx<User> user;

  @override
  void onInit() {
    user = Rx<User>(client.auth.currentUser!);
    super.onInit();
  }

  Future<UserData> getUserData() async {
    var userData = await client.from('user_data').select().eq('user_id', user.value.id);
    UserData userDataModel = UserData.fromJson(userData[0]);

    return userDataModel;
  }
}

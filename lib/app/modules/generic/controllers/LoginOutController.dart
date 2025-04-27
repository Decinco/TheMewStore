import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/modules/generic/controllers/FriendNotificationController.dart';

class LogInOutController extends GetxController {
  RxBool loggedIn = false.obs;
  SupabaseClient client = Supabase.instance.client;

  late String firstpage;

  @override
  void onInit() async {
    await dotenv.load(fileName: ".env");
    firstpage = dotenv.env['DEFAULT_FIRST_PAGE'] ?? '/home';

    super.onInit();
    _subscribeToAuth();
  }

  void _subscribeToAuth() {
    client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        loggedIn.value = true;
      } else if (event == AuthChangeEvent.signedOut) {
        loggedIn.value = false;
      }
    });
  }

  void initNavigationListener() {
    firstNavigation();
    Future.delayed(Duration(seconds: 2), () {
      navigateBasedOnListener();
    });

    ever(loggedIn, (value) {
      navigateBasedOnListener();
    });
  }

  void firstNavigation() {
    User? user = client.auth.currentUser;

    if (user != null) {
      loggedIn.value = true;
    } else {
      loggedIn.value = false;
    }
  }

  void navigateBasedOnListener() {
    if (loggedIn.value) {
      Get.offAllNamed(firstpage);
    } else {
      Get.offAllNamed('/login');
    }
  }

  void logOut() async {
    await client.auth.signOut();
    loggedIn.value = false;
  }
}

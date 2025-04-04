import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInOutController extends GetxController {
  RxBool loggedIn = false.obs;
  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
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
    //navigateBasedOnListener();

    ever(loggedIn, (value) {
        navigateBasedOnListener();
    });
  }

  void navigateBasedOnListener() {
    if (loggedIn.value) {
      if (Get.currentRoute == '/login') {
        Get.offAllNamed('/home');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }
}

import 'package:get/get.dart';

import '../controllers/profilefriends_controller.dart';

class ProfilefriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilefriendsController>(
      () => ProfilefriendsController(),
    );
  }
}

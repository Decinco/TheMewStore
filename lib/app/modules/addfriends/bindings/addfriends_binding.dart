import 'package:get/get.dart';

import '../controllers/addfriends_controller.dart';

class AddfriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddfriendsController>(
      () => AddfriendsController(),
    );
  }
}

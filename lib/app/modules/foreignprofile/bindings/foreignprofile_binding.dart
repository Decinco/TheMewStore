import 'package:get/get.dart';

import '../controllers/foreignprofile_controller.dart';

class ForeignprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForeignprofileController>(
      () => ForeignprofileController(),
    );
  }
}

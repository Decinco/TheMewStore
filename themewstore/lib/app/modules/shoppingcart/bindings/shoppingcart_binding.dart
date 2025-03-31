import 'package:get/get.dart';

import '../controllers/shoppingcart_controller.dart';

class ShoppingcartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShoppingcartController>(
      () => ShoppingcartController(),
    );
  }
}

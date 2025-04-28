import 'package:get/get.dart';
import '../controllers/foreignprofile_controller.dart';

class ForeignprofileBinding extends Bindings {
  @override
  void dependencies() {
    // Obtén el uuid de los parámetros de ruta o usa uno por defecto
    final uuid = Get.arguments;

    Get.lazyPut<ForeignprofileController>(
          () => ForeignprofileController(uuid),
    );
  }
}
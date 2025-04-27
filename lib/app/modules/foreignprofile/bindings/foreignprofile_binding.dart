import 'package:get/get.dart';
import '../controllers/foreignprofile_controller.dart';

class ForeignprofileBinding extends Bindings {
  @override
  void dependencies() {
    // Obtén el uuid de los parámetros de ruta o usa uno por defecto
    final uuid = Get.parameters['uuid'] ?? "31c14ddf-fc64-4982-b087-3e840955d510";

    Get.lazyPut<ForeignprofileController>(
          () => ForeignprofileController(uuid),
    );
  }
}
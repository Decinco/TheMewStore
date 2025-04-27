import 'package:get/get.dart';
import '../controllers/foreignprofile_controller.dart';

class ForeignprofileBinding extends Bindings {
  @override
  void dependencies() {
    // Obtén el uuid de los parámetros de ruta o usa uno por defecto
    final uuid = Get.parameters['uuid'] ?? "107d8c84-c74d-4988-9d01-6226057c26b9";

    Get.lazyPut<ForeignprofileController>(
          () => ForeignprofileController(uuid),
    );
  }
}
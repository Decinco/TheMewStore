import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/addfriends_controller.dart';

class MobileScannerScreen extends StatelessWidget {
  final AddfriendsController controller = Get.find<AddfriendsController>();

  MobileScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(),
      onDetect: (barcode, args) async {
        if (barcode.rawValue == null) {
          debugPrint('No se detectó ningún código QR.');
          return;
        }

        final String code = barcode.rawValue!;
        debugPrint('QR detectado: $code');

        // Para evitar escanear el mismo código muchas veces rápidamente
        if (controller.scannedCodes.contains(code)) return;
        controller.scannedCodes.add(code);

        // Buscar el usuario por el código escaneado
        final userData = await controller.searchUserByCode(code);

        if (userData != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(userData['user_name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData['profile_picture']),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text('Código: ${userData['user_code']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        } else {
          // Mostrar error si el usuario no existe
          Get.snackbar(
            'Usuario no encontrado',
            'No existe ningún usuario con ese código.',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}

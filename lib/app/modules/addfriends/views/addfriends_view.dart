import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <- Importante
import '../controllers/addfriends_controller.dart';

class AddfriendsView extends GetView<AddfriendsController> {
  const AddfriendsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
          title: const Text('Add Friend', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Show QR Code'),
              Tab(text: 'Scan QR Code'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Primer tab: Show QR Code
            Center(
              child: Obx(() {
                return Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.profilePicture.value.isNotEmpty)
                        CircleAvatar(
                          backgroundImage: NetworkImage(controller.profilePicture.value),
                          radius: 40,
                        )
                      else
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                      const SizedBox(height: 20),
                      if (controller.userCode.value.isNotEmpty)
                        QrImageView(
                          data: controller.userCode.value,
                          version: QrVersions.auto,
                          size: 150,
                        )
                      else
                        const Text('No QR disponible'),
                      const SizedBox(height: 20),
                      Text(
                        controller.userName.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.userCode.value,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),
            ),

            // Segundo tab: Scan QR Code
            MobileScanner(
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null && !controller.scannedCodes.contains(code)) {
                    controller.scannedCodes.add(code); // Evitar múltiples lecturas del mismo

                    final userData = await controller.searchUserByCode(code);

                    if (userData != null) {
                      Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Text('Usuario encontrado'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userData['profile_picture']),
                                radius: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userData['user_name'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(userData['user_code'], style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Get.snackbar('No encontrado', 'No se encontró un usuario con este código.',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

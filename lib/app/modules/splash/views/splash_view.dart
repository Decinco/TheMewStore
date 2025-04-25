import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 237, 213, 229),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 213, 229),
        body: Stack(
          children: [
            // Imagen principal centrada
            Center(
              child: Image.asset(
                'assets/images/themewstore/themewstore.png',
              ),
            ),
            // GIF en la parte inferior central
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom:
                        30.0), // Ajusta la distancia desde el borde inferior
                child: Image.asset(
                  'assets/images/themewstore/mew_splash.gif', // Ruta de tu GIF
                  height: 100.0, // Ajusta el tamaño del GIF según sea necesario
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

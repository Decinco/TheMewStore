import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var nicknameController = TextEditingController();
  var emailController = TextEditingController();

  var selectedLanguage = 'English'.obs;

  // Variables observables para controlar la visibilidad de las contraseñas
  var passwordVisible = false.obs;
  var confirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Limpiar controladores al cerrar el controlador
    passwordController.dispose();
    confirmPasswordController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Método para cambiar el idioma seleccionado
  void changeLanguage(String newLanguage) {
    selectedLanguage.value = newLanguage;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD5E5),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black), // Agregar el ícono de las tres barras
          onPressed: () {
            // Aquí puedes agregar la lógica para abrir un menú lateral (drawer) si lo tienes configurado
            print("Menu button pressed");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Get.back(), // Cierra la pantalla
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFEDD5E5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Change Password:', controller.passwordController, obscureText: true),
            _buildTextField('Confirm Password:', controller.confirmPasswordController, obscureText: true),
            _buildDropdown('Language:', controller),
            _buildTextField('Change Nickname:', controller.nicknameController),
            _buildTextField('Change E-Mail:', controller.emailController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Validar campos antes de guardar
                  if (_validateFields(context)) {
                    // Aquí puedes manejar la lógica de guardado (ej. guardar cambios)
                    print("Changes saved");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    final password = controller.passwordController.text;
    final confirmPassword = controller.confirmPasswordController.text;
    final nickname = controller.nicknameController.text;
    final email = controller.emailController.text;

    // Verificar que las contraseñas coincidan
    if (password != confirmPassword) {
      _showErrorMessage(context, "Passwords do not match!");
      return false;
    }

    // Verificar que todos los campos estén llenos
    if (nickname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorMessage(context, "All fields must be filled out!");
      return false;
    }

    return true; // Si todas las validaciones pasan, retornar true
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, SettingsController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Obx(
                () => DropdownButtonFormField<String>(
              value: controller.selectedLanguage.value,
              items: ['English', 'Spanish', 'French']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) => controller.selectedLanguage.value = value!,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

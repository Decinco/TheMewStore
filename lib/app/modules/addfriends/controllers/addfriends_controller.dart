import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddfriendsController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  var profilePicture = ''.obs; // URL de la foto de perfil del usuario actual
  var userName = ''.obs;        // Nombre del usuario actual
  var userCode = ''.obs;        // Código único del usuario actual
  var scannedCodes = <String>[].obs; // Códigos QR ya escaneados para evitar repeticiones

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Carga los datos del usuario actual desde la tabla user_data
  Future<void> loadUserData() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    final data = await client
        .from('user_data')
        .select()
        .eq('user_id', user.id)
        .single();

    profilePicture.value = data['profile_picture'] ?? '';
    userName.value = data['user_name'] ?? '';
    userCode.value = data['user_code'] ?? '';
  }

  /// Busca un usuario en la base de datos por el código QR escaneado
  Future<Map<String, dynamic>?> searchUserByCode(String code) async {
    final response = await client
        .from('user_data')
        .select()
        .eq('user_code', code)
        .maybeSingle();

    return response;
  }
}

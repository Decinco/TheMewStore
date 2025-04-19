// lib/app/modules/map/controllers/map_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Alias para evitar choque de nombres con tu clase MapController
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapController extends GetxController {
  //final fm.MapController mapController = fm.MapController();
  final RxList<fm.Marker> markers = <fm.Marker>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isFullScreen = false.obs;
  final RxList<String> searchSuggestions = <String>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool showSuggestions = false.obs; // Nueva variable de estado

  late final fm.MapController mapController; // Declaración late

  @override
  void onInit() {
    super.onInit();
    mapController = fm.MapController();
    fetchLocations();
  }

  Future<void> fetchLocations({String? filter}) async {
    final client = Supabase.instance.client;

    var query = client.from('map').select('location, lat, lng, description_user');

    if (filter != null && filter.isNotEmpty) {
      query = query.ilike('location', '%$filter%');
    }

    try {
      final List<dynamic> rows = await query;

      final suggestions = rows.map<String>((e) => e['location'] as String).toList();
      searchSuggestions.assignAll(suggestions);

      final newMarkers = rows.map<fm.Marker>((entry) {
        final data = entry as Map<String, dynamic>;
        return fm.Marker(
          point: LatLng(data['lat'], data['lng']),
          width: 40,
          height: 40,
          builder: (ctx) => GestureDetector(
            onTap: () => Get.snackbar(data['location'], data['description_user']),
            child: const Icon(
              Icons.location_pin,
              size: 40,
              color: Colors.red,
            ),
          ),
        );
      }).toList();

      markers.assignAll(newMarkers);

    } catch (e) {
      showErrorMessage('Error al cargar ubicaciones: ${e.toString()}');
    }

    showSuggestions.value = filter != null && filter.isNotEmpty;

  }

  void onSearch() async {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      fetchLocations();
      return;
    }

    // Verificar si la sugerencia existe
    if (!searchSuggestions.any((s) => s.toLowerCase() == text.toLowerCase())) {
      showErrorMessage('Ubicación no encontrada');
      return;
    }

    await fetchLocations(filter: text);

    // Centrar el mapa en la primera coincidencia
    if (markers.isNotEmpty) {
      final firstMarker = markers.first;
      mapController.move(firstMarker.point, mapController.zoom);
    }
  }

  void showErrorMessage(String message) {
    errorMessage.value = message;
    Future.delayed(const Duration(seconds: 3), () => errorMessage.value = '');
  }

  void onZoomFullScreen() {
    isFullScreen.toggle();
    if (markers.isNotEmpty) {
      final bounds = fm.LatLngBounds.fromPoints(
          markers.map((m) => m.point).toList()
      );
      mapController.fitBounds(bounds);
    }
  }

}

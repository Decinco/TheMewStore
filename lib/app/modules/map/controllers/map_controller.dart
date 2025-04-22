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

  Future<void> fetchLocations({String? filter, bool exact = false}) async {
    final client = Supabase.instance.client;

    try {
      var query =
          client.from('map').select('location, lat, lng, description_user');

      if (filter != null && filter.isNotEmpty) {
        query = exact
            ? query.eq('location', filter) // Búsqueda exacta
            : query.ilike('location', '%$filter%'); // Búsqueda parcial
      }

      final List<dynamic> rows = await query;

      // Solo actualizar sugerencias si no es búsqueda exacta
      if (!exact) {
        final locations =
            rows.map<String>((e) => e['location'] as String).toList();
        searchSuggestions.assignAll(locations);
      }

      markers.assignAll(rows.map<fm.Marker>((entry) {
        final data = entry as Map<String, dynamic>;
        return fm.Marker(
          point: LatLng(data['lat'], data['lng']),
          builder: (ctx) => GestureDetector(
            onTap: () =>
                Get.snackbar(data['location'], data['description_user']),
            child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),
        );
      }));
    } catch (e) {
      showErrorMessage('Error: ${e.toString()}');
    }
  }

  void onSearch() async {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      fetchLocations();
      return;
    }

    // Buscar coincidencia exacta
    final client = Supabase.instance.client;
    try {
      final List<dynamic> rows = await client
          .from('map')
          .select('location, lat, lng, description_user')
          .eq('location', text);

      if (rows.isEmpty) {
        showErrorMessage('Ubicación no encontrada');
        return;
      }

      // Actualizar marcadores
      markers.assignAll(rows.map<fm.Marker>((entry) {
        final data = entry as Map<String, dynamic>;
        return fm.Marker(
          point: LatLng(data['lat'], data['lng']),
          builder: (ctx) => GestureDetector(
            onTap: () =>
                Get.snackbar(data['location'], data['description_user']),
            child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),
        );
      }));

      // Mover mapa al marcador
      if (markers.isNotEmpty) {
        mapController.move(markers.first.point, 18);
      }
    } catch (e) {
      showErrorMessage('Error: ${e.toString()}');
    }
  }

  void showErrorMessage(String message) {
    errorMessage.value = message;
    Future.delayed(const Duration(seconds: 3), () => errorMessage.value = '');
  }

  void onZoomFullScreen() {
    isFullScreen.toggle();
    if (markers.isNotEmpty) {
      final bounds =
          fm.LatLngBounds.fromPoints(markers.map((m) => m.point).toList());
      mapController.fitBounds(bounds);
    }
  }

  void selectLocation(String location) async {
    // 1. Asignar el texto al controlador
    searchController.text = location;

    // 2. Forzar la lista de sugerencias a solo este elemento
    searchSuggestions.assignAll([location]);

    // 3. Realizar búsqueda exacta
    await fetchLocations(filter: location, exact: true);

    // 4. Mover el mapa al marcador
    if (markers.isNotEmpty) {
      mapController.move(markers.first.point, 18);
    }

    // 5. Ocultar sugerencias
    showSuggestions.value = false;
  }
}

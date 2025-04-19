// lib/app/modules/map/controllers/map_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Alias para evitar choque de nombres con tu clase MapController
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapController extends GetxController {
  /// El controller de flutter_map, alias fm
  final fm.MapController mapController = fm.MapController();
  /// Lista reactiva de marcadores de flutter_map
  //final markers = <fm.Marker>[].obs;
  final RxList<fm.Marker> markers = <fm.Marker>[].obs; // Declaración explícita
  /// Controlador del TextField de búsqueda
  final TextEditingController searchController = TextEditingController();
  final RxBool isFullScreen = false.obs; // Nuevo estado reactivo


  @override
  void onInit() {
    super.onInit();
    // Carga inicial de ubicaciones
    fetchLocations();
  }

  /// Consulta supabase en la tabla 'locations' y actualiza marcadores
  /// Obtiene ubicaciones de Supabase y actualiza marcadores
  Future<void> fetchLocations({String? filter}) async {
    final client = Supabase.instance.client;

    // Construye la consulta
    var builder = client.from('locations').select();
    if (filter?.isNotEmpty == true) {
      builder = builder.ilike('name', '%${filter}%');
    }

    try {
      // Await directo devuelve List<dynamic>
      final List<dynamic> rows = await builder;

      final newMarkers = rows.map<fm.Marker>((entry) {
        final row = entry as Map<String, dynamic>;
        return fm.Marker(
          point: LatLng(
            (row['lat'] as num).toDouble(),
            (row['lng'] as num).toDouble(),
          ),
          width: 40,
          height: 40,
          builder: (ctx) => GestureDetector(
            onTap: () => Get.snackbar('Location', row['name'] as String),
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
      Get.snackbar('Error', e.toString());
    }
  }


  /// Llama a fetchLocations con el texto del TextField
  void onSearch() {
    final text = searchController.text.trim();
    fetchLocations(filter: text.isEmpty ? null : text);
  }

  /// Ajusta zoom para mostrar todos los marcadores
  /// Alterna entre modo pantalla completa
  void onZoomFullScreen() {
    isFullScreen.toggle();

    if (isFullScreen.value) {
      // Opcional: Ajustar zoom al activar pantalla completa
      mapController.move(mapController.center, mapController.zoom + 1);
    }
  }
}

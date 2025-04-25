// lib/app/modules/map/controllers/map_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../uicon.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapController extends GetxController {
  late final fm.MapController mapController;
  final RxList<fm.Marker> markers = <fm.Marker>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isFullScreen = false.obs;
  final RxList<String> searchSuggestions = <String>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool showSuggestions = false.obs;
  

  final double minZoom = 12.0;  // Nivel mínimo para alejar
  final double maxZoom = 18.0;  // Nivel máximo para acercar (reduce este valor)
  final double initialZoom = 16.0;  // Zoom inicial intermedio


  /// Datos de la ubicación seleccionada para info
  final Rxn<Map<String, dynamic>> selectedLocation = Rxn();

  @override
  void onInit() {
    super.onInit();
    mapController = fm.MapController();
    // Mover el mapa después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(LatLng(41.3851, 2.1734), initialZoom);
      fetchLocations();
    });
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
          width: 40.0,
          height: 40.0,
          builder: (ctx) => GestureDetector(
            onTap: () => selectMarker(data),
            child: const Icon(UIcons.fibsmarker, size: 40, color: Colors.red),
          ),
        );
      }));
    } catch (e) {
      showErrorMessage('Error: ${e.toString()}');
    }
  }


  /// Búsqueda exacta y centrado, mostrando info
  Future<void> onSearch() async {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      await fetchLocations();
      return;
    }
    try {
      final rows = await Supabase.instance.client
          .from('map')
          .select('location, lat, lng, description_user')
          .eq('location', text);
      if (rows.isEmpty) {
        showErrorMessage('Ubicación no encontrada');
        return;
      }
      // Generar marcadores y centrar
      await fetchLocations(filter: text, exact: true);
      final data = rows.first as Map<String, dynamic>;
      selectMarker(data);
    } catch (e) {
      showErrorMessage('Error: ${e.toString()}');
    }
  }
  final RxBool showLocationCard = false.obs;

  /// Selecciona un marcador y muestra el card
  void selectMarker(Map<String, dynamic> data) {
    selectedLocation.value = data;
    showLocationCard.value = true;
    mapController.move(
      LatLng(data['lat'], data['lng']),
      mapController.zoom,
    );
  }

  /// Cierra el card de información
  void closeLocationCard() {
    showLocationCard.value = false;
    selectedLocation.value = null;
  }

  /// Seleccionar ubicación desde sugerencias de búsqueda
  Future<void> selectLocation(String location) async {
    // 1) Mostrar solo esta sugerencia
    searchSuggestions.assignAll([location]);
    // 2) Establecer en campo y ocultar lista
    searchController.text = location;
    showSuggestions.value = false;
    // 3) Ejecutar búsqueda exacta (centrado + panel)
    await onSearch();
  }

  /// Limpia la selección de marcador
  void clearSelection() => selectedLocation.value = null;

  /// Mostrar mensaje de error temporal
  void showErrorMessage(String message) {
    errorMessage.value = message;
    Future.delayed(const Duration(seconds: 3), () => errorMessage.value = '');
  }

  void onZoomFullScreen() {
    isFullScreen.toggle();
    if (markers.isNotEmpty) {
      final bounds = fm.LatLngBounds.fromPoints(
        markers.map((m) => m.point).toList(),
      );
      mapController.fitBounds(
        bounds,
        options: fm.FitBoundsOptions(
          padding: EdgeInsets.all(20),
          maxZoom: maxZoom,  // Asegúrate de aplicar el límite máximo aquí
        ),
      );
    }
  }

}

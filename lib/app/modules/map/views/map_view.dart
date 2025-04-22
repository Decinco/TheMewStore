import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5),
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD5E5),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: GestureDetector(
          onTap: () => Get.toNamed('/home'),
          child: const Text(
            'Sellers Near You',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.black),
            onPressed: controller.onZoomFullScreen,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Mapa con margen superior para el buscador
          Positioned.fill(
            child: Obx(
                  () => Container(
                margin: controller.isFullScreen.value
                    ? EdgeInsets.zero
                    : const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: fm.FlutterMap(
                  mapController: controller.mapController,
                  options: fm.MapOptions(
                    center: LatLng(41.3851, 2.1734),
                    zoom: 12,
                    onMapReady: () {
                      controller.mapController.move(LatLng(41.3851, 2.1734), 12);
                    },
                  ),
                  children: [
                    fm.TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a','b','c'],
                    ),
                    fm.MarkerLayer(
                      markers: controller.markers,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Capa para cerrar sugerencias al tocar fuera
          Positioned.fill(
            child: Obx(() => controller.showSuggestions.value
                ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => controller.showSuggestions.value = false,
            )
                : const SizedBox.shrink()),
          ),

          // Barra de búsqueda con estilo integrado
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Obx(() => controller.errorMessage.isNotEmpty
                    ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.red[100],
                  child: Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
                    : const SizedBox.shrink()),
                TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar tiendas...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      filled: true,
                      fillColor: const Color(0xFFEDD5E5),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: controller.onSearch,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onTap: () {
                      controller.showSuggestions.value = true;
                      if (controller.searchController.text.isEmpty) {
                        controller.fetchLocations();
                      }
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // Solo buscar si no estamos en modo de selección única
                        if (controller.searchSuggestions.length != 1 ||
                            controller.searchSuggestions.first != value) {
                          controller.fetchLocations(filter: value);
                        }
                        controller.showSuggestions.value = true;
                      } else {
                        controller.searchSuggestions.clear();
                        controller.showSuggestions.value = false;
                      }
                    },
                    onSubmitted: (_) {
                      controller.onSearch();
                      controller.showSuggestions.value = false;
                    }
                ),
                Obx(() => controller.showSuggestions.value &&
                    controller.searchSuggestions.isNotEmpty
                    ? Container(
                  constraints: BoxConstraints(
                    maxHeight: 56 * controller.searchSuggestions.length.clamp(1, 3).toDouble(),
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDD5E5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: controller.searchSuggestions.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        controller.searchSuggestions[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        controller.selectLocation(controller.searchSuggestions[index]);
                      },
                    ),
                  ),
                )
                    : const SizedBox.shrink()),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
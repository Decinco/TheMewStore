import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart';
import '../../../../uicon.dart';

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
            icon: const Icon(UIcons.fibsmenuburger, color: Colors.black),
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
            icon: const Icon(UIcons.fibsexpandarrows, color: Colors.black),
            onPressed: controller.onZoomFullScreen,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() => Stack(
        children: [
          // 1. Mapa (fondo)
          Positioned.fill(
            child: Container(
              margin: controller.isFullScreen.value
                  ? EdgeInsets.zero
                  : const EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: fm.FlutterMap(
                mapController: controller.mapController,
                options: fm.MapOptions(
                  center: LatLng(41.3851, 2.1734),
                  zoom: controller.initialZoom,
                  minZoom: controller.minZoom,
                  maxZoom: controller.maxZoom,
                  onMapReady: () {
                    controller.mapController.move(
                      LatLng(41.3851, 2.1734),
                      controller.initialZoom,
                    );
                  },
                ),
                children: [
                  fm.TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  fm.MarkerLayer(
                    markers: controller.markers,
                  ),
                ],
              ),
            ),
          ),

          // 2. Capa de cierre de sugerencias
          if (controller.showSuggestions.value)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => controller.showSuggestions.value = false,
              ),
            ),

          // 3. Barra de búsqueda
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (controller.errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.red[100],
                    child: Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar tiendas...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(UIcons.fibssearch, color: Colors.black),
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
                    },
                  ),
                ),
                if (controller.showSuggestions.value &&
                    controller.searchSuggestions.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 56 *
                          controller.searchSuggestions.length.clamp(1, 3).toDouble(),
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.searchSuggestions.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          controller.searchSuggestions[index],
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          controller.selectLocation(
                              controller.searchSuggestions[index]);
                        },
                      ),
                    ),
                  ),

              ],
            ),
          ),


          // 4. Card de información (último para que esté encima de todo)
          if (controller.showLocationCard.value &&
              controller.selectedLocation.value != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildLocationCard(context, controller.selectedLocation.value!),
            ),
        ],
      )),
    );
  }

  Widget _buildLocationCard(BuildContext context, Map<String, dynamic> location) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location['location'] ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(UIcons.fibscross),
                  onPressed: controller.closeLocationCard,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              location['description_user'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
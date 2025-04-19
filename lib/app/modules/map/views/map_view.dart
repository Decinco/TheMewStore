// lib/app/modules/map/views/map_view.dart

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
        // Abre el drawer con Builder() para que funcione el context
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: controller.onSearch,
                    ),
                  ),
                  onTap: () => controller.showSuggestions.value = true,
                  onChanged: (value) {
                  controller.fetchLocations(filter: value);
                  controller.showSuggestions.value = value.isNotEmpty;
                  },
                  onSubmitted: (_) {
                    controller.onSearch();
                    controller.showSuggestions.value = false;
                  }
                ),
                Obx(() => controller.showSuggestions.value && controller.searchSuggestions.isNotEmpty
                    ? Container(

                height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: controller.searchSuggestions.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(controller.searchSuggestions[index]),
                      onTap: () {
                        controller.searchController.text =
                        controller.searchSuggestions[index];
                        controller.onSearch();
                      },
                    ),
                  ),
                )
                    : const SizedBox.shrink()),
              ],
            ),
          ),

          Expanded(
            child: Obx(
                  () => Container(
                margin: controller.isFullScreen.value
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(20),
                child: fm.FlutterMap(
                  mapController: controller.mapController,
                  options: fm.MapOptions(
                    center: LatLng(41.3851, 2.1734), // Coordenadas de Barcelona
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
                      markers: controller.markers, // Eliminado .value
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

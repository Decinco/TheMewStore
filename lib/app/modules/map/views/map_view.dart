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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => controller.onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: controller.onSearch,
                ),
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
                    center: LatLng(40.4168, -3.7038),
                    zoom: 13,
                  ),
                  children: [
                    fm.TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a','b','c'],
                    ),
                    fm.MarkerLayer(
                      markers: controller.markers.isNotEmpty
                          ? controller.markers.value
                          : [],
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

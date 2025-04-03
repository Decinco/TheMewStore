import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5), // Color de fondo similar al de la imagen
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD5E5), // Color de la barra de arriba
        elevation: 0,
        title: const Text(
          'Sellers Near You',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Acción al presionar el menú
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map_rounded, color: Colors.black), // Ícono para hacer zoom
            onPressed: () {
              // Acción al presionar el icono de zoom
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                // Acción para la búsqueda
              },
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Mapa no visible aquí',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

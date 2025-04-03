import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:themewstore/uicon.dart';
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
          'Traders Near You',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(UIcons.fibsmenuburger, color: Colors.black, size: 30), // Icono más grande
          onPressed: () {
            // Acción al presionar el menú
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(UIcons.fibsexpandarrows, color: Colors.black, size: 30), // Icono de zoom más grande
            onPressed: () {
              // Acción al presionar el icono de zoom
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda con estilo personalizado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Borde redondeado
              child: TextField(
                controller: TextEditingController(), // Agregué un TextEditingController para el buscador
                onChanged: (value) {
                  // Acción para la búsqueda
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search, color: Colors.grey), // Ícono de lupa
                  label: Text("Buscar..."), // Etiqueta para el campo de búsqueda
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Container blanco con borde redondeado y margen en todos los lados
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Márgenes laterales
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Borde redondeado para el contenedor
                child: Container(
                  width: double.infinity,
                  color: Colors.white, // Fondo blanco
                  child: Center(
                    child: Text(
                      'Mapa no visible aquí',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Espaciado adicional abajo
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/shoppingcart_controller.dart';

class ShoppingcartView extends GetView<ShoppingcartController> {
  const ShoppingcartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD5E5),
        elevation: 0,
        title: const Text(
          'Shopping cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag, color: Colors.black, size: 28),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.zoom_in, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Carrusel de productos
          Expanded(
            child: Obx(() => CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.6,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  controller.currentPage.value = index;
                },
              ),
              items: controller.cartItems.map((item) {
                int index = controller.cartItems.indexOf(item); // Obtener el índice de cada item
                return _cartItem(index); // Usa tu función para generar el item del carrito
              }).toList(),
            )),
          ),
          // Paginación y botones
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _quantityButton(Icons.chevron_left, controller.previousPage,
                        enabled: controller.currentPage.value > 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${controller.currentPage.value + 1} / ${controller.cartItems.length}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _quantityButton(Icons.chevron_right, controller.nextPage,
                        enabled: controller.currentPage.value < controller.cartItems.length - 1),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.removeItem(); // Eliminación de artículo
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text('Pay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _cartItem(int index) {
    return Obx(() {
      final item = controller.cartItems[index];
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(item["image"], width: 150, height: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(item["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(item["price"], style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _quantityButton(Icons.remove, () => controller.decrement(index),
                      enabled: controller.cartItems[index]["quantity"].value > 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item["quantity"].value.toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _quantityButton(Icons.add, () => controller.increment(index),
                      enabled: controller.cartItems[index]["quantity"].value < 100),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed, {bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: enabled ? Colors.grey : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: enabled ? Colors.black : Colors.grey.shade400),
      ),
    );
  }
}

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
        title: GestureDetector(
          onTap: () {
            Get.offAllNamed('/home'); // <-- Asegúrate de que la ruta exista
          },
          child: const Text(
            'Shopping cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
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
                icon: const Icon(Icons.shopping_bag,
                    color: Colors.black, size: 28),
                onPressed: () {},
              ),
              Obx(() {
                return controller.cartItems.isEmpty
                    ? Container()
                    : Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            controller.filteredCartItems.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
              }),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                controller.filterProducts(value);
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
          Expanded(
            child: Obx(() {
              if (controller.filteredCartItems.isEmpty) {
                return const Center(
                  child: Text(
                    "No hay ningún producto disponible",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.65,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    controller.currentPage.value = index;
                  },
                ),
                carouselController: controller.carouselController,
                items:
                    controller.filteredCartItems.asMap().entries.map((entry) {
                  return _cartItem(entry.key);
                }).toList(),
              );
            }),
          ),
          Obx(() => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _quantityButton(
                            Icons.chevron_left, controller.previousPage,
                            enabled: controller.currentPage.value > 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            controller.filteredCartItems.isEmpty
                                ? "0 / 0"
                                : "${controller.currentPage.value + 1} / ${controller.filteredCartItems.length}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _quantityButton(
                            Icons.chevron_right, controller.nextPage,
                            enabled: controller.currentPage.value <
                                controller.filteredCartItems.length - 1),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: controller.filteredCartItems.isEmpty
                              ? null
                              : controller.removeItem,
                          icon: const Icon(Icons.delete,
                              color: Colors.white, size: 24),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.red.shade500, // Fondo rojo oscuro
                          ),
                          label: const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Remove',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: controller.filteredCartItems.isEmpty
                                ? null
                                : () {},
                            icon: const Icon(Icons.payment,
                                color: Colors.white, size: 24),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Colors.green.shade500, // Fondo verde oscuro
                            ),
                            label: Obx(() {
                              return Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Pay ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          '${controller.totalAmount.toStringAsFixed(2)}€',
                                    ),
                                  ],
                                ),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              );
                            }),
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
      final item = controller.filteredCartItems[index];
      final imageUrl = item["image"]?.toString() ?? '';
      final productId = item['product_id'].toString();

      return Card(
        key: Key(productId),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    headers: const {'Cache-Control': 'no-cache'},
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('''
                            Error cargando imagen:
                            Producto ID: $productId
                            URL: $imageUrl
                            Error: $error
                          ''');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 40),
                          Text(
                            'Error loading image\nID: $productId',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  )
                      : Image.asset('assets/placeholder.png'),
                ),
              ),

              Text(item["name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text("${item["price"].toStringAsFixed(2)}€",
                  style: const TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _quantityButton(
                      Icons.remove, () => controller.decrement(index),
                      enabled: item["quantity"].value > 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item["quantity"].value.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _quantityButton(
                    Icons.add,
                        () => controller.increment(index),
                    // <-- aquí usamos el stock real
                    enabled: item["quantity"].value < (item["stock"] as int),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed,
      {bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border:
              Border.all(color: enabled ? Colors.grey : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 18, color: enabled ? Colors.black : Colors.grey.shade400),
      ),
    );
  }
}

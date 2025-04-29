import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:themewstore/app/modules/generic/sidebar/hamburguesa.dart';
import '../../../../generated/locales.g.dart';
import '../../../../uicon.dart';
import '../controllers/shoppingcart_controller.dart';

class ShoppingcartView extends GetView<ShoppingcartController> {
  const ShoppingcartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5),
      drawer: Hamburguesa(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(
                UIcons.fibsmenuburger,
                size: 35,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEDD5E5),
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Get.offAllNamed('/home'); // <-- Asegúrate de que la ruta exista
          },
          child: Text(
              LocaleKeys.shoppingcart_title.tr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                UIcons.fibscross,
                size: 35,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              onPressed: () => Get.back(),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.filteredCartItems.isEmpty) {
                return Center(
                  child: Text(
                      LocaleKeys.shoppingcart_empty.tr,
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
                          label: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: LocaleKeys.shoppingcart_remove.tr,
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
                                  : () => controller.placeOrder(),
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
                                    TextSpan(
                                      text: '${LocaleKeys.shoppingcart_checkout.tr} ',
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
                                const Icon(Icons.error,
                                    color: Colors.red, size: 40),
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
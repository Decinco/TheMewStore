import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:themewstore/uicon.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/productStock.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String getPublicImageUrl(String path) =>
      Supabase.instance.client.storage.from('productimages').getPublicUrl(path);

  /// Helper para mostrar precio: si hay oferta, muestra solo precio con descuento en rojo
  Widget _buildPriceWidget(ProductStock product) {
    // Normalizamos offerId por si viniera como String o null
    int? offerId;
    final raw = product.offerId;
    if (raw is int) offerId = raw;
    else if (raw is String) offerId = int.tryParse(raw);

    if (offerId != null && controller.discounts.containsKey(offerId)) {
      final pct       = controller.discounts[offerId]!;
      final newPrice  = product.price * (1 - pct / 100);
      return Text(
        '${newPrice.toStringAsFixed(2)}€',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }
    // Sin oferta: precio normal en negro
    return Text(
      '${product.price.toStringAsFixed(2)}€',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Cabecera del drawer
            Container(
              color: const Color.fromRGBO(237, 213, 229, 1),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/themewstore/themewstore.png',
                    width: 50,
                    height: 50,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Ítems del drawer
            ListTile(
              leading: const Icon(UIcons.fibsuser),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/profile');
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsshoppingbag),
              title: const Text('Cesta'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/shoppingcart');
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsmap),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/map');
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsfollowing),
              title: const Text('Amigos'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/profilefriends');
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsexit),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                controller.logOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('The Mew Store', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(UIcons.fibsshoppingbag, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/themewstore/themewstore.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filtros de rango de precio
          Obx(() {
            if (controller.searchQuery.value.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Precio: ${controller.selectedRange.value.start.toStringAsFixed(0)}€ - ${controller.selectedRange.value.end.toStringAsFixed(0)}€',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: () => controller.showFilters.toggle(),
                      ),
                    ],
                  ),
                ),
                if (controller.showFilters.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RangeSlider(
                      values: controller.selectedRange.value,
                      min: controller.minPrice.value,
                      max: controller.maxPrice.value,
                      labels: RangeLabels(
                        '${controller.selectedRange.value.start.toStringAsFixed(0)}€',
                        '${controller.selectedRange.value.end.toStringAsFixed(0)}€',
                      ),
                      onChanged: controller.updatePriceRange,
                    ),
                  ),
              ],
            );
          }),

          // Contenido principal
          Expanded(
            child: Obx(() {
              // Lista cuando hay búsqueda
              if (controller.searchQuery.value.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: controller.products.length,
                  itemBuilder: (context, i) {
                    final p = controller.products[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            getPublicImageUrl(p.image),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(p.productName),
                        subtitle: _buildPriceWidget(p),
                        onTap: () => Get.toNamed('/product', arguments: {
                          'id': p.productId,
                          'product_name': p.productName,
                          'price': p.price,
                          'description': p.description,
                          'image': getPublicImageUrl(p.image),
                          'stock': p.stock,
                        }),
                      ),
                    );
                  },
                );
              }

              // Carrusel + grid principal
              return Column(
                children: [
                  slider.CarouselSlider(
                    options: slider.CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: controller.products.map((p) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          getPublicImageUrl(p.image),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, i) {
                        final p = controller.products[i];
                        return GestureDetector(
                          onTap: () => Get.toNamed('/product', arguments: {
                            'id': p.productId,
                            'product_name': p.productName,
                            'price': p.price,
                            'description': p.description,
                            'image': getPublicImageUrl(p.image),
                            'stock': p.stock,
                          }),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  getPublicImageUrl(p.image),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 4),
                                    ],
                                  ),
                                  child: _buildPriceWidget(p),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

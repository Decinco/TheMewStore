import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:themewstore/uicon.dart';
import '../controllers/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String getPublicImageUrl(String path) {
    return Supabase.instance.client.storage
        .from('productimages')
        .getPublicUrl(path);
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
            Container(
              color: const Color.fromRGBO(237, 213, 229, 1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/themewstore/themewstore.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(UIcons.fibsuser),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navegar a pantalla de perfil
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsshoppingbag),
              title: const Text('Cesta'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navegar a pantalla de cesta
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsmap),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navegar a pantalla de mapa
              },
            ),
            ListTile(
              leading: const Icon(UIcons.fibsfollowing),
              title: const Text('Amigos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navegar a pantalla de amigos
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
          children: [
            const Text(
              'The Mew Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            const Icon(UIcons.fibsshoppingbag, color: Colors.black),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
          Expanded(
            child: Obx(
                  () {
                // Si hay texto en la búsqueda, mostrar lista de resultados
                if (controller.searchQuery.value.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              getPublicImageUrl(product.image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                            ),
                          ),
                          title: Text(product.productName),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                          onTap: () {
                            Get.toNamed('/product', arguments: {
                              'id': product.productId,
                              'product_name': product.productName,
                              'price': product.price,
                              'description': product.description,
                              'image': getPublicImageUrl(product.image),
                              'stock': product.stock
                            });
                          },
                        ),
                      );
                    },
                  );
                }
                // Si no hay búsqueda, mostrar carrusel y rejilla
                return Column(
                  children: [
                    Obx(
                          () => controller.products.isNotEmpty
                          ? slider.CarouselSlider(
                        options: slider.CarouselOptions(
                          height: 220,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        items: controller.products.map((product) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              getPublicImageUrl(product.image),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image, size: 50),
                            ),
                          );
                        }).toList(),
                      )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    Expanded(
                      child: Obx(
                            () => controller.products.isNotEmpty
                            ? GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed('/product', arguments: {
                                  'id': product.productId,
                                  'product_name': product.productName,
                                  'price': product.price,
                                  'description':
                                  product.description,
                                  'image': getPublicImageUrl(
                                      product.image),
                                  'stock': product.stock
                                });
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    child: Image.network(
                                      getPublicImageUrl(product.image),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.broken_image, size: 50),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(
                                            2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : const Center(
                            child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:themewstore/uicon.dart';
import '../controllers/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String getPublicImageUrl(String path) {
    return Supabase.instance.client.storage.from('productimages').getPublicUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The Mew Store', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Image.asset('../../../assets/images/themewstore.png', height: 30),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(UIcons.fibsbell),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/user.png', width: 50, height: 50),
            const SizedBox(height: 20),
            IconButton(
              icon: Image.asset('assets/pokemon_button.png'),
              iconSize: 50,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: Image.asset('assets/stock_button.png'),
              iconSize: 50,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: Image.asset('assets/payment_button.png'),
              iconSize: 50,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: Image.asset('assets/users_button.png'),
              iconSize: 50,
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
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
          Obx(() => controller.products.isNotEmpty
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
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                ),
              );
            }).toList(),
          )
              : const Center(child: CircularProgressIndicator())),
          Expanded(
            child: Obx(() => controller.products.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        getPublicImageUrl(product.image),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
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
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
                : const Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:themewstore/uicon.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 213, 229, 100),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The Mew Store', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Icon(UIcons.fibsshoppingbag, color: Colors.black),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(237, 213, 229, 100),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(UIcons.fibsbell),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Carousel Slider with products
          Obx(() => controller.products.isNotEmpty
              ? slider.CarouselSlider(
            options: slider.CarouselOptions(height: 260, autoPlay: true),
            items: controller.products.map((product) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.pink[50]),
                    child: Image.network(product.image, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
          )
              : const Center(child: CircularProgressIndicator())),

          // GridView of products
          Expanded(
            child: Obx(() => controller.products.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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

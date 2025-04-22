import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// imports...
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String getPublicImageUrl(String path) {
    return Supabase.instance.client.storage
        .from('productimages')
        .getPublicUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('The Mew Store',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
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
            icon: Image.asset(
                '../../../../assets/images/themewstore/themewstore.png'),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        width: 100,
        backgroundColor: const Color(0xFFF4CCE7),
        child: Column(
          children: [
            const SizedBox(height: 40),
            IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _drawerIcon('../../../../assets/images/themewstore/user.png',
                      () {
                    Get.toNamed('/profile');
                  }),
                  _drawerIcon('../../../../assets/images/themewstore/bag.png',
                      () {
                    Get.toNamed('/cart');
                  }),
                  _drawerIcon('../../../../assets/images/themewstore/map.png',
                      () {
                    Get.toNamed('/map');
                  }),
                  _drawerIcon('../../../../assets/images/themewstore/peso.png',
                      () {
                    Get.toNamed('/currency');
                  }),
                  _drawerIcon(
                      '../../../../assets/images/themewstore/friends.png', () {
                    Get.toNamed('/friends');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
          Obx(() => controller.showFilters.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton(
                        icon: const Icon(Icons.filter_list),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Obx(() => DropdownButton<String>(
                                  value:
                                      controller.selectedExpansion.value.isEmpty
                                          ? null
                                          : controller.selectedExpansion.value,
                                  hint: const Text('Filtrar por expansión'),
                                  items: controller.expansionOptions
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text('Expansión $e')))
                                      .toList(),
                                  onChanged: (value) {
                                    controller.selectedExpansion.value =
                                        value ?? '';
                                    controller.filterProducts();
                                    Navigator.pop(context);
                                  },
                                )),
                          ),
                          PopupMenuItem(
                            child: Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Filtrar por precio máximo'),
                                    Slider(
                                      value: controller.selectedPrice.value,
                                      min: 0,
                                      max: controller.maxPrice.value,
                                      divisions: 20,
                                      label:
                                          '\$${controller.selectedPrice.value.toStringAsFixed(2)}',
                                      onChanged: (value) {
                                        controller.selectedPrice.value = value;
                                        controller.filterProducts();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          PopupMenuItem(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.selectedExpansion.value = '';
                                controller.selectedPrice.value =
                                    controller.maxPrice.value;
                                controller.filterProducts();
                                Navigator.pop(context);
                              },
                              child: const Text('Quitar filtros'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          Expanded(
            child: Obx(() {
              final products = controller.products;
              return products.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
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
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  getPublicImageUrl(product.image),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 4),
                                    ],
                                  ),
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No se encontraron productos'));
            }),
          ),
        ],
      ),
    );
  }

  Widget _drawerIcon(String assetPath, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.white,
            child: Center(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

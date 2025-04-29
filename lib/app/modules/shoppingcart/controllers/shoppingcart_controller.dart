import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../generated/locales.g.dart';
import '../../product/controllers/product_controller.dart';

extension CarouselControllerExtension on CarouselController {
  // Para navegar a la siguiente página
  void nextPageWithAnimation(CarouselController controller, int currentPage,
      {Duration duration = const Duration(milliseconds: 300)}) {
    controller.animateToPage(currentPage + 1, duration: duration);
  }

  // Para navegar a la página anterior
  void previousPageWithAnimation(CarouselController controller, int currentPage,
      {Duration duration = const Duration(milliseconds: 300)}) {
    controller.animateToPage(currentPage - 1, duration: duration);
  }

  // Para ir a una página específica con animación
  // En tu extensión
  void animateToPage(int page,
      {Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.easeInOut}) {
    animateToPage(page, duration: duration, curve: curve);
  }
}

class ShoppingcartController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  var cartItems = <Map<String, dynamic>>[].obs;
  var currentPage = 0.obs;
  var filteredCartItems = <Map<String, dynamic>>[].obs;
  //final CarouselController carouselController = CarouselController();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  /// Fetch cart items including product data and stock
  Future<void> fetchCartItems() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    // Select product data including stock
    final response = await client.from('shopping_cart').select('''
            quantity,
            product:product_id (
              product_id,
              product_name,
              price,
              image,
              description,
              stock
            )
          ''').eq('user_id', user.id);

    cartItems.assignAll(_parseCartItems(response));
    filteredCartItems.assignAll(cartItems);
  }

  /// Parse Supabase response into local model
  List<Map<String, dynamic>> _parseCartItems(List<dynamic> data) {
    return data.map((item) {
      final product = item['product'] as Map<String, dynamic>;
      // Generate public URL for image
      final imagePath = product['image']?.toString() ?? '';
      final imageUrl = imagePath.isNotEmpty
          ? client.storage.from('productimages').getPublicUrl(imagePath)
          : '';

      return {
        'product_id': product['product_id'] as int,
        'name': product['product_name'] as String,
        'price': (product['price'] as num).toDouble(),
        'image': imageUrl,
        'description': product['description'] as String,
        'stock': product['stock'] as int,
        'quantity': (item['quantity'] as int).obs,
      };
    }).toList();
  }

  /// Upsert cart item with new quantity and total price
  Future<void> _updateCartQuantity(
      int productId, int newQuantity, double price) async {
    final user = client.auth.currentUser;
    if (user == null) return;

    final totalPrice = newQuantity * price;
    await client.from('shopping_cart').upsert({
      'user_id': user.id,
      'product_id': productId,
      'quantity': newQuantity,
      'total_price': totalPrice,
    });
  }

  void increment(int index) async {
    final item = filteredCartItems[index];
    final current = item['quantity'].value as int;
    final stock = item['stock'] as int;

    if (current < stock) {
      // 1) Actualizas solo el observable
      item['quantity'].value++;

      await _updateCartQuantity(
        item['product_id'],
        item['quantity'].value,
        item['price'],
      );

      // 3) (opcional) refrescar totalAmount u otros cálculos, pero sin fetchCartItems()
    } else {
      Get.snackbar(LocaleKeys.errors_title_physicalError.tr, LocaleKeys.errors_description_outOfStock.tr);
    }
  }

  void decrement(int index) async {
    final item = filteredCartItems[index];
    final current = item['quantity'].value as int;

    if (current > 1) {
      item['quantity'].value--;
      await _updateCartQuantity(
        item['product_id'],
        item['quantity'].value,
        item['price'],
      );
    } else {
      Get.snackbar(LocaleKeys.errors_title_userError.tr, LocaleKeys.errors_description_amountLessThanOne.tr,);
    }
  }

  void removeItem() async {
    if (filteredCartItems.isEmpty) return;

    final user = client.auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    try {
      final item = filteredCartItems[currentPage.value];
      final productId = item['product_id'] as int; // Asegurar tipo int

      // Eliminar de la base de datos
      await client
          .from('shopping_cart')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);

      // Actualizar listas locales inmediatamente
      cartItems.removeWhere((element) => element['product_id'] == productId);
      filteredCartItems
          .removeWhere((element) => element['product_id'] == productId);

      // Actualizar UI
      cartItems.refresh();
      filteredCartItems.refresh();

      // Ajustar paginación
      if (filteredCartItems.isNotEmpty) {
        currentPage.value =
            currentPage.value.clamp(0, filteredCartItems.length - 1);
        carouselController.jumpToPage(currentPage.value);
      } else {
        currentPage.value = 0;
      }

      // Actualizar contadores
      Get.find<ProductController>().updateCartQuantityFromDB();
    } catch (e) {
      Get.snackbar('Error', e.toString(),);
    }
  }

  double get totalAmount {
    return filteredCartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity'].value);
    });
  }

  void nextPage() {
    if (currentPage.value < cartItems.length - 1) {
      currentPage.value++;
      carouselController.animateToPage(currentPage.value);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      carouselController.animateToPage(currentPage.value);
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredCartItems.assignAll(cartItems); // Si está vacío, mostrar todos
    } else {
      filteredCartItems.assignAll(cartItems
          .where((item) =>
              item["name"].toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  // Obtener el número total de productos en el carrito
  int get totalItems => cartItems.length;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../product/controllers/product_controller.dart';

// Extensión de CarouselController para manejar la navegación entre páginas
extension CarouselControllerExtension on CarouselController {
  // Para navegar a la siguiente página
  void nextPageWithAnimation(CarouselController controller, int currentPage, {Duration duration = const Duration(milliseconds: 300)}) {
    controller.animateToPage(currentPage + 1, duration: duration);
  }

  // Para navegar a la página anterior
  void previousPageWithAnimation(CarouselController controller, int currentPage, {Duration duration = const Duration(milliseconds: 300)}) {
    controller.animateToPage(currentPage - 1, duration: duration);
  }

  // Para ir a una página específica con animación
  // En tu extensión
  void animateToPage(int page, {Duration duration = const Duration(milliseconds: 300), Curve curve = Curves.easeInOut}) {
    this.animateToPage(page, duration: duration, curve: curve);
  }
}

class ShoppingcartController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;
  var cartItems = <Map<String, dynamic>>[].obs;
  var currentPage = 0.obs;
  var filteredCartItems = <Map<String, dynamic>>[].obs;
  //final CarouselController carouselController = CarouselController();
  final CarouselSliderController carouselController = CarouselSliderController();
  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await client
          .from('shopping_cart')
          .select('''
            quantity, 
            product_stock: product_id (
              product_id,
              product_name,
              price,
              image,
              description
            )
          ''')
          .eq('user_id', user.id);

      cartItems.assignAll(_parseCartItems(response));
      filteredCartItems.assignAll(cartItems);
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  List<Map<String, dynamic>> _parseCartItems(List<dynamic> data) {
    return data.map((item) {
      final product = item['product_stock'];
      return {
        'product_id': product['product_id'],
        'name': product['product_name'],
        'price': product['price'].toDouble(),
        'image': product['image'],
        'description': product['description'],
        'quantity': (item['quantity'] as int).obs,
      };
    }).toList();
  }

  Future<void> _updateCartQuantity(int productId, int newQuantity) async {
    final user = client.auth.currentUser;
    if (user == null) return;

    await client.from('shopping_cart').upsert({
      'user_id': user.id,
      'product_id': productId,
      'quantity': newQuantity,
    });
  }

  void increment(int index) async {
    final item = filteredCartItems[index];
    item['quantity'].value++;
    await _updateCartQuantity(item['product_id'], item['quantity'].value);
    fetchCartItems();
  }

  void decrement(int index) async {
    final item = filteredCartItems[index];
    if (item['quantity'].value > 1) {
      item['quantity'].value--;
      await _updateCartQuantity(item['product_id'], item['quantity'].value);
      fetchCartItems();
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
      await client.from('shopping_cart')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);

      // Actualizar listas locales inmediatamente
      cartItems.removeWhere((element) => element['product_id'] == productId);
      filteredCartItems.removeWhere((element) => element['product_id'] == productId);

      // Actualizar UI
      cartItems.refresh();
      filteredCartItems.refresh();

      // Ajustar paginación
      if (filteredCartItems.isNotEmpty) {
        currentPage.value = currentPage.value.clamp(0, filteredCartItems.length - 1);
        carouselController.jumpToPage(currentPage.value);
      } else {
        currentPage.value = 0;
      }

      // Actualizar contadores
      Get.find<ProductController>().updateCartQuantityFromDB();
      Get.snackbar('Éxito', 'Producto eliminado',
          snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      print('Error eliminando: ${e.toString()}');
      Get.snackbar('Error', 'No se pudo eliminar: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
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
      filteredCartItems.assignAll(cartItems.where((item) =>
          item["name"].toLowerCase().contains(query.toLowerCase())).toList());
    }
  }
  // Obtener el número total de productos en el carrito
  int get totalItems => cartItems.length;
}

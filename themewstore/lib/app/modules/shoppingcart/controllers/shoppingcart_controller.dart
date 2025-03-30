import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  var cartItems = <Map<String, dynamic>>[
    {
      "name": "10 Sobres de Pokemon 1 Gen.",
      "price": "49,99€",
      "image": "https://m.media-amazon.com/images/I/71Fhp8m+gaL._AC_SY450_.jpg",
      "description": "Son sobres originales y god pack asegurado.",
      "quantity": 1.obs,
    },
    {
      "name": "kjhg.",
      "price": "60.00€",
      "image": "https://m.media-amazon.com/images/I/71Fhp8m+gaL._AC_SY450_.jpg",
      "description": "Son sobres originales y god pack asegurado.",
      "quantity": 1.obs,
    },
    {
      "name": "10 Sobres de Pokemon 1 Gen.",
      "price": "49,99€",
      "image": "https://m.media-amazon.com/images/I/71Fhp8m+gaL._AC_SY450_.jpg",
      "description": "Son sobres originales y god pack asegurado.",
      "quantity": 1.obs,
    },
    {
      "name": "sd.",
      "price": "50.00€",
      "image": "https://m.media-amazon.com/images/I/71Fhp8m+gaL._AC_SY450_.jpg",
      "description": "Son sobres originales y god pack asegurado.",
      "quantity": 1.obs,
    },
  ].obs;

  var currentPage = 0.obs;
  var filteredCartItems = <Map<String, dynamic>>[].obs; // Lista filtrada

  final CarouselSliderController carouselController = CarouselSliderController();
  @override

  void onInit() {
    super.onInit();
    filteredCartItems.assignAll(cartItems); // Inicializa la lista filtrada
  }

  // Filtrar productos por nombre
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredCartItems.assignAll(cartItems); // Si está vacío, mostrar todos
    } else {
      filteredCartItems.assignAll(cartItems.where((item) =>
          item["name"].toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  // Incrementar cantidad y mover el carrusel al índice
  void increment(int index) {
    cartItems[index]["quantity"].value++;
    carouselController.animateToPage(index); // Mueve el carrusel al item correspondiente
  }

  // Decrementar cantidad y mover el carrusel al índice
  void decrement(int index) {
    if (cartItems[index]["quantity"].value > 1) {
      cartItems[index]["quantity"].value--;
      carouselController.animateToPage(index); // Mueve el carrusel al item correspondiente
    }
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


  // Eliminar el producto actual del carrito
  void removeItem() {
    if (filteredCartItems.isNotEmpty) {
      int index = currentPage.value;
      var removedItem = filteredCartItems[index]; // Guardamos el item a eliminar

      // Eliminar el producto de ambas listas
      cartItems.removeWhere((item) => item == removedItem);
      filteredCartItems.removeAt(index);

      // Ajustar la página actual
      if (currentPage.value >= filteredCartItems.length && currentPage.value > 0) {
        currentPage.value--;
      }
    }
  }

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) {
      double price = double.tryParse(item["price"].replaceAll("€", "").replaceAll(",", ".")) ?? 0.0;
      return sum + (price * item["quantity"].value);
    });
  }

  // Obtener el número total de productos en el carrito
  int get totalItems => cartItems.length;
}

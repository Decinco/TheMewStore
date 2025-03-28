import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  void animateToPage(int page, {Duration duration = const Duration(milliseconds: 300)}) {
    animateToPage(page); // Usamos `jumpToPage` para la animación suave
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
  final CarouselController carouselController = CarouselController();

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

  // Pasar al siguiente producto en el carrusel
  void nextPage() {
    if (currentPage.value < cartItems.length - 1) {
      currentPage.value++;
      carouselController.nextPageWithAnimation(carouselController, currentPage.value, duration: Duration(milliseconds: 300)); // Desplaza el carrusel
    }
  }

  // Pasar al producto anterior en el carrusel
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      carouselController.previousPageWithAnimation(carouselController, currentPage.value, duration: Duration(milliseconds: 300)); // Desplaza el carrusel
    }
  }

  // Eliminar el producto actual del carrito
  void removeItem() {
    if (cartItems.isNotEmpty) {
      cartItems.removeAt(currentPage.value);
      if (currentPage.value >= cartItems.length && currentPage.value > 0) {
        currentPage.value--;
      }
    }
  }

  // Obtener el número total de productos en el carrito
  int get totalItems => cartItems.length;
}

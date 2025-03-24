import 'package:get/get.dart';

class ProductController extends GetxController {
  var quantity = 1.obs;
  var rating = 4.0.obs; // Puntuación inicial
  var isFavorite = false.obs;
  var cartQuantity = 0.obs; // Cantidad de productos en la bolsa de compras

  var comments = <Comment>[].obs; // Lista de comentarios

  void increaseQuantity() {
    quantity.value++; // Ya no hay límite
  }

  void decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void setRating(int newRating) {
    if (rating.value == newRating.toDouble()) {
      rating.value = newRating - 1 > 0 ? (newRating - 1).toDouble() : 0.0;
    } else {
      rating.value = newRating.toDouble();
    }
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  void addToCart() {
    if (cartQuantity.value < 9) {
      cartQuantity.value++;
    } else {
      cartQuantity.value = 10; // Para mostrar "+9"
    }
  }

  void addComment(String user, String comment, int rating) {
    if (comment.isNotEmpty) {
      comments.add(Comment(user: user, text: comment, rating: rating));
    }
  }

  void toggleCommentFavorite(int index) {
    comments[index].isFavorite.value = !comments[index].isFavorite.value;
    comments.refresh();
  }

  void setCommentRating(int index, int newRating) {
    comments[index].rating.value = newRating;
    comments.refresh(); // Asegura que GetX actualice la UI
  }

}

class Comment {
  String user;
  String text;
  RxInt rating;
  RxBool isFavorite;

  Comment({required this.user, required this.text, required int rating})
      : rating = rating.obs,
        isFavorite = false.obs;
}

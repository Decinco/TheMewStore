import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  var quantity = 1.obs;
  var cartQuantity = 0.obs;
  var comments = <Comment>[].obs;
  var stock = 0.obs;  // Aquí añadimos el stock
  // Para cargar desde el HomeView
  var product = {}.obs;

  void setProduct(Map<String, dynamic> data) {
    product.value = data;
    stock.value = product['stock'] ?? 0;  // Cargar el stock del producto
  }

  Future<void> loadComments(dynamic productId) async {
    try {
      final data = await client
          .from('comments')
          .select()
          .eq('product_id', productId.toString()) // 👈 convertir a String
          .order('created_at', ascending: false);

      comments.value = (data as List).map((c) => Comment.fromMap(c)).toList();
    } catch (e) {
      print('Error cargando comentarios: $e');
    }
  }

  Future<void> addComment(String user, String text, int rating) async {
    final newComment = {
      'product_id': product['id'].toString(), // 👈 convertir a String
      'user': user,
      'text': text,
      'rating': rating,
    };

    try {
      final response = await client.from('comments').insert(newComment);
      if (response != null) {
        comments.insert(0, Comment(user: user, text: text, rating: rating));
      }
    } catch (e) {
      print('Error insertando comentario: $e');
    }
  }

  // Función para aumentar la cantidad, respetando el stock
  void increaseQuantity() {
    if (quantity.value < stock.value) {
      quantity.value++;
    }
  }
  // Función para disminuir la cantidad, sin bajar de 1
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
  void addToCart() {
    cartQuantity.value = cartQuantity.value < 9 ? cartQuantity.value + 1 : 10;
  }

  void toggleCommentFavorite(int index) {
    comments[index].isFavorite.value = !comments[index].isFavorite.value;
    comments.refresh();
  }

  Future<void> addToCartAndSync() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      return;
    }

    try {
      final int productId = product['id'];
      final int qty = quantity.value;

      // Obtener la cantidad actual del carrito desde Supabase
      final response = await client
          .from('shopping_cart')
          .select('quantity')
          .eq('user_id', currentUser.id)
          .eq('product_id', productId)
          .single();

      int currentQuantity = 0;
      if (response != null && response.isNotEmpty) {
        currentQuantity = response['quantity'] ?? 0;
      }

      // Sumar la nueva cantidad a la existente
      final newQuantity = currentQuantity + qty;

      // Actualizar o insertar en la base de datos
      await client.from('shopping_cart').upsert({
        'user_id': currentUser.id,
        'product_id': productId,
        'quantity': newQuantity,
      }, onConflict: 'product_id, user_id');

      // Actualizar el estado local del carrito
      cartQuantity.value += qty;

    } catch (e) {
    }
  }
}

class Comment {
  String user;
  String text;
  RxInt rating;
  RxBool isFavorite;

  Comment({
    required this.user,
    required this.text,
    required int rating,
  })  : rating = rating.obs,
        isFavorite = false.obs;

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      user: map['user'] ?? 'Anónimo',
      text: map['text'] ?? '',
      rating: map['rating'] ?? 0,
    );
  }
}

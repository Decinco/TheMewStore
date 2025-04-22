import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../../../data/models/comment.dart';
import '../../shoppingcart/controllers/shoppingcart_controller.dart';

class ProductController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  var quantity = 1.obs;
  var cartQuantity = 0.obs;
  var comments = <Comment>[].obs;
  var stock = 0.obs;  // Aquí añadimos el stock
  // Para cargar desde el HomeView
  var product = {}.obs;

  Future<void> updateCartQuantityFromDB() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    try {
      final response = await client
          .from('shopping_cart')
          .select('product_id')
          .eq('user_id', currentUser.id);
      cartQuantity.value = response.length;
    } catch (e) {
      Get.snackbar("Error", "Error");
    }
  }

  void setProduct(Map<String, dynamic> data) {
    product.value = data;
    stock.value = product['stock'] ?? 0;  // Cargar el stock del producto
  }

  Future<void> loadComments(dynamic productId) async {
    try {
      final data = await client
          .from('product_comments')
          .select('content, rating, created_at, user_data(user_name)')
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      comments.value = (data as List).map((c) => Comment.fromMap(c)).toList();
    } catch (e) {
    }
  }


  Future<void> addComment(String content, int rating) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    final productId = product['id'];
    if (productId == null) return;

    final newComment = {
      'product_id': product['id'], // este sí tiene valor
      'user_id': currentUser.id,
      'content': content,
      'rating': rating,
    };

    try {
      await client.from('product_comments').insert(newComment);
      await loadComments(productId); // Recarga comentarios desde la base de datos
    } catch (e) {
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
    if (currentUser == null) return;

    try {
      final int productId = product['id'];
      final int qty = quantity.value;
      final double price = product['price'];
      final int maxStock = stock.value;

      // Obtener cantidad actual en carrito
      final response = await client
          .from('shopping_cart')
          .select('quantity')
          .eq('user_id', currentUser.id)
          .eq('product_id', productId)
          .maybeSingle();

      int currentQuantity = 0;
      if (response != null && response.isNotEmpty) {
        currentQuantity = response['quantity'] ?? 0;
      }

      // Calcular nueva cantidad sin superar el stock
      final int availableToAdd = maxStock - currentQuantity;
      if (availableToAdd <= 0) {
        // Ya se alcanzó el stock máximo, no añadimos más
        Get.snackbar('Stock alcanzado', 'Ya tienes la cantidad máxima en el carrito.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final int quantityToAdd = qty > availableToAdd ? availableToAdd : qty;
      final int newQuantity = currentQuantity + quantityToAdd;

      await client.from('shopping_cart').upsert({
        'user_id': currentUser.id,
        'product_id': productId,
        'quantity': newQuantity,
        'total_price': newQuantity * price,
      }, onConflict: 'product_id, user_id');

      await updateCartQuantityFromDB();
      Get.find<ShoppingcartController>().fetchCartItems();

      // Opcional: notificación al usuario
      Get.snackbar('Añadido al carrito', 'Se añadieron $quantityToAdd unidades.',
          snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      Get.snackbar('Error', 'No se pudo añadir al carrito.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  @override
  void onInit() {
    super.onInit();
    updateCartQuantityFromDB();
  }
}
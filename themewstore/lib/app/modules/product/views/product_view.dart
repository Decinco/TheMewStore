import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

void _showCommentDialog(BuildContext context, ProductController controller) {
  TextEditingController userController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  RxInt rating = 0.obs;

  Get.defaultDialog(
    title: "Añadir Comentario",
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: userController,
          decoration: const InputDecoration(
            hintText: "Tu nombre...",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: "Escribe tu comentario...",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                if (rating.value == index + 1) {
                  rating.value = index; // Si ya estaba seleccionada, se quita
                } else {
                  rating.value = index + 1; // Si no estaba, se añade
                }
              },

              child: Icon(
                index < rating.value ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
            );
          }),
        )),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (userController.text.isNotEmpty && commentController.text.isNotEmpty) {
              controller.addComment(userController.text, commentController.text, rating.value);
              Get.back();
            }
          },
          child: const Text("Añadir"),
        ),
      ],
    ),
  );
}

class ProductView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDD5E5),
        title: const Text(
          'The Mew Store',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Obx(
                () => IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.black),
                  if (controller.cartQuantity.value > 0)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                        child: Text(
                          controller.cartQuantity.value > 9 ? '+9' : '${controller.cartQuantity.value}',
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {},
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta del producto
              Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '10 Sobres de Pokemon 1 Gen.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text('49,99 €', style: TextStyle(fontSize: 16, color: Colors.black54)),
                          const SizedBox(height: 10),
                          Center(child: Image.asset('assets/pokemon_cards.png', height: 150)),
                          const SizedBox(height: 10),
                          const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Son sobres originales y god pack asegurado.\n-Mucho Texto'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: controller.decreaseQuantity),
                              Obx(() => Text('${controller.quantity}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: controller.increaseQuantity),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: controller.addToCart,
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Añadir al Carrito'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Get.back()),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sección de comentarios
              const Text('Reseñas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Obx(
                    () => controller.comments.isEmpty
                    ? const Center(child: Text('No hay reseñas aún.'))
                    : Column(
                  children: controller.comments.map((comment) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 24)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.user, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      5,
                                          (index) => Icon(
                                        index < comment.rating.value ? Icons.star : Icons.star_border,
                                        color: Colors.yellow,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(comment.text, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Obx(
                                  () => IconButton(
                                icon: Icon(
                                  comment.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                                  color: comment.isFavorite.value ? Colors.red : Colors.black,
                                ),
                                onPressed: () => controller.toggleCommentFavorite(controller.comments.indexOf(comment)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Botón de añadir comentario siempre al final
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showCommentDialog(context, controller),
                  icon: const Icon(Icons.add_comment),
                  label: const Text('Añadir Reseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

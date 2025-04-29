import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:themewstore/app/modules/generic/sidebar/hamburguesa.dart';
import '../../../../generated/locales.g.dart';
import '../../../../uicon.dart';
import '../../shoppingcart/controllers/shoppingcart_controller.dart';
import '../../shoppingcart/views/shoppingcart_view.dart';
import '../controllers/product_controller.dart';

void _showCommentDialog(BuildContext context, ProductController controller) {
  //final userController = TextEditingController();
  final commentController = TextEditingController();
  final rating = 0.obs;

  Get.defaultDialog(
    title: LocaleKeys.product_addReview.tr,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: LocaleKeys.product_writeComment.tr,
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
                    rating.value =
                        rating.value == index + 1 ? index : index + 1;
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
          onPressed: () async {
            if (commentController.text.isNotEmpty) {
              await controller.addComment(
                commentController.text,
                rating.value,
              );
              Get.back();
            }
          },
          child: Text(LocaleKeys.product_addComment.tr),
        ),
      ],
    ),
  );
}

class ProductView extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();

  ProductView({super.key}) {
    // Este se ejecuta al momento de construir la vista y recibe los argumentos pasados
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      controller.setProduct(args);
      controller.loadComments(args['id']); // Carga los comentarios también
    }
  }
  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      backgroundColor: const Color(0xFFEDD5E5),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(
                UIcons.fibsmenuburger,
                size: 35,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEDD5E5),
        title: Text(LocaleKeys.theMewStore.tr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // En el AppBar de ProductView
          Obx(() => Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        UIcons.fibsshoppingbag,
                        color: Color.fromRGBO(78, 78, 78, 1),
                        size: 35,
                      ),
                      if (controller.cartQuantity.value > 0)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.red,
                            child: Text(
                              controller.cartQuantity.value > 9
                                  ? '+9'
                                  : '${controller.cartQuantity.value}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    Get.toNamed("/shoppingcart");
                  }))),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Hamburguesa(),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            product['product_name'] ??
                                LocaleKeys.product_noName_product.tr,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              '${(product['price'] as num).toStringAsFixed(2)} €',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54)),
                          const SizedBox(height: 10),
                          Center(
                            child: product['image'] != null
                                ? Image.network(product['image'] as String,
                                    height: 150)
                                : Image.asset('assets/placeholder.png',
                                    height: 150),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              product['comments'] ??
                                  LocaleKeys.product_noName_comments.tr,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(product['description'] ??
                              LocaleKeys.product_noName_description.tr),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: controller.decreaseQuantity),
                              Obx(() => Text('${controller.quantity}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                              IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: controller.increaseQuantity),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: controller.addToCartAndSync,
                              icon: const Icon(Icons.shopping_cart),
                              label: Text(LocaleKeys.product_addToCart.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Get.back()),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reseñas
              Text(LocaleKeys.product_reviews.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Obx(() => controller.comments.isEmpty
                  ? Center(child: Text(LocaleKeys.product_noReviews.tr))
                  : Column(
                      children: controller.comments.map((comment) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                    radius: 24,
                                    child: Icon(Icons.person, size: 24)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.user,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            index < comment.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(comment.text,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Obx(() => IconButton(
                                      icon: Icon(
                                        comment.isFavorite.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: comment.isFavorite.value
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      onPressed: () =>
                                          controller.toggleCommentFavorite(
                                              controller.comments
                                                  .indexOf(comment)),
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showCommentDialog(context, controller),
                  icon: const Icon(Icons.add_comment),
                  label: Text(LocaleKeys.product_addReview.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shoppingcart_controller.dart';

class ShoppingcartView extends GetView<ShoppingcartController> {
  const ShoppingcartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShoppingcartView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShoppingcartView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

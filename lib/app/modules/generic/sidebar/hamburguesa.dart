import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:themewstore/generated/locales.g.dart';

import '../../../../uicon.dart';
import '../controllers/LoginOutController.dart';

class Hamburguesa extends StatelessWidget {
  const Hamburguesa({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInOutController>();

    return Drawer(
      backgroundColor: const Color.fromRGBO(237, 213, 229, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Cabecera del drawer
          Container(
            color: const Color.fromRGBO(237, 213, 229, 1),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/themewstore/themewstore.png',
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(UIcons.fibsshoppingcart),
            title: Text(LocaleKeys.burger_theMewStore.tr),
            onTap: () {
              Navigator.pop(context);
              Get.offAllNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(UIcons.fibsshoppingbag),
            title: Text(LocaleKeys.burger_shoppingCart.tr),
            onTap: () {
              Navigator.pop(context);
              Get.offAllNamed('/shoppingcart');
            },
          ),
          ListTile(
            leading: const Icon(UIcons.fibsmap),
            title: Text(LocaleKeys.burger_map.tr),
            onTap: () {
              Navigator.pop(context);
              Get.offAllNamed('/map');
            },
          ),
          ListTile(
            leading: const Icon(UIcons.fibsuser),
            title: Text(LocaleKeys.burger_profileFriends.tr),
            onTap: () {
              Navigator.pop(context);
              Get.offAllNamed('/profilefriends');
            },
          ),
          ListTile(
            leading: const Icon(UIcons.fibsexit,
                color: Colors.red),
            title: Text(LocaleKeys.burger_logOut.tr,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              controller.logOut();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/modules/generic/controllers/LoginOutController.dart';
import 'app/routes/app_pages.dart';

<<<<<<< HEAD
Future main() async{
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  Get.put(LogInOutController());

=======
import 'app/modules/product/views/product_view.dart';

void main() {
>>>>>>> feature/product
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onReady: () => Get.find<LogInOutController>().initNavigationListener(),
      title: "Application",
      initialRoute: AppPages.INITIAL, //splash
      getPages: AppPages.routes,
<<<<<<< HEAD
      theme: ThemeData(
        fontFamily: 'Inter'
      ),
    ),
=======
        debugShowCheckedModeBanner: false
    )
>>>>>>> feature/product
  );
}
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/userData.dart';
import '../../../data/models/productStock.dart';
import 'package:flutter/material.dart';


class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  late Rx<User> user;

  var allProducts = <ProductStock>[].obs;
  var products = <ProductStock>[].obs;
  var searchQuery = ''.obs;

  // Filtrado por precio
  var minPrice = 0.0.obs;
  var maxPrice = 1000.0.obs;
  var selectedRange = RangeValues(0.0, 1000.0).obs;

  var showFilters = false.obs;
  var selectedExpansion = ''.obs; // TODO: Agregar expansiones
  var expansionOptions = <String>[].obs;

  @override
  void onInit() {
    User? currentUser = client.auth.currentUser;
    if (currentUser != null) {
      user = Rx<User>(currentUser);
      fetchProducts();
    }
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await client.from('product_stock').select();

      // 1) Mapea la respuesta y asigna allProducts
      final productsList = response
          .map<ProductStock>((item) => ProductStock.fromJson(item))
          .toList();
      allProducts.value = productsList;

      // 2) Calcula min/max de precio solo si hay elementos
      if (productsList.isNotEmpty) {
        minPrice.value = productsList
            .map((p) => p.price)
            .reduce((a, b) => a < b ? a : b);
        maxPrice.value = productsList
            .map((p) => p.price)
            .reduce((a, b) => a > b ? a : b);
      } else {
        minPrice.value = 0.0;
        maxPrice.value = 0.0;
      }
      // Inicializa el rango completo
      selectedRange.value = RangeValues(minPrice.value, maxPrice.value);

      // 3) Resto de inicializaciones
      expansionOptions.value =
          productsList.map((p) => p.expansionId.toString()).toSet().toList();
      _setRandomProducts();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _setRandomProducts() {
    final shuffled = [...allProducts]..shuffle();
    products.value = shuffled.take(6).toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      _setRandomProducts();
    } else {
      filterProducts();
    }
  }

  void updatePriceRange(RangeValues range) {
    selectedRange.value = range;
    filterProducts();
  }

  void filterProducts() {
    final q = searchQuery.value.trim().toLowerCase();
    final words =
    q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    final filtered = allProducts.where((p) {
      final name = p.productName.toLowerCase();
      final matchesText =
          words.isEmpty || words.any((word) => name.contains(word));
      final price = p.price;
      final inRange = price >= selectedRange.value.start &&
          price <= selectedRange.value.end;
      return matchesText && inRange;
    }).toList();

    products.value = filtered;
  }

  Future<UserData> getUserData() async {
    var userData = await client
        .from('user_data')
        .select()
        .eq('user_id', user.value.id);
    return UserData.fromJson(userData[0]);
  }

  Future<void> logOut() async {
    await client.auth.signOut();
  }
}

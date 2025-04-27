// home_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../../data/models/productStock.dart';
import '../../../data/models/userData.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  late Rx<User> user;

  // Mapa de offerId a % de descuento
  Map<int, int> discounts = {};

  var allProducts = <ProductStock>[].obs;
  var products    = <ProductStock>[].obs;
  var searchQuery = ''.obs;

  // Rango de precios
  var minPrice      = 0.0.obs;
  var maxPrice      = 1000.0.obs;
  var selectedRange = RangeValues(0.0, 1000.0).obs;

  var showFilters       = false.obs;
  var selectedExpansion = ''.obs;
  var expansionOptions  = <String>[].obs;

  @override
  void onInit() {
    final current = client.auth.currentUser;
    if (current != null) {
      user = Rx<User>(current);
      fetchProducts();
    }
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      // 1) Productos (igual que antes)
      final respProd = await client.from('product_stock').select();
      final prodList = (respProd as List).map((e) => ProductStock.fromJson(e)).toList();

      // 2) Ofertas: solo los campos que nos importan, para evitar nulls
      final respOff = await client
          .from('offer')
          .select('offer_id, discount_percentage');

      final Map<int,int> temp = {};
      for (final row in respOff as List) {
        final id  = row['offer_id'];
        final pct = row['discount_percentage'];
        if (id is int && pct is int) {
          temp[id] = pct;
        }
      }
      discounts = temp;

      allProducts.value = prodList;

      // 3) Rango precios
      if (prodList.isNotEmpty) {
        minPrice.value = prodList.map((p) => p.price).reduce((a,b) => a<b?a:b);
        maxPrice.value = prodList.map((p) => p.price).reduce((a,b) => a>b?a:b);
      } else {
        minPrice.value = maxPrice.value = 0.0;
      }
      selectedRange.value = RangeValues(minPrice.value, maxPrice.value);

      expansionOptions.value = prodList
          .map((p) => p.expansionId.toString())
          .toSet()
          .toList();

      _setRandomProducts();
    } catch (err) {
      print('Error fetching products/offers: $err');
    }
  }

  void _setRandomProducts() {
    final shuffled = [...allProducts]..shuffle();
    products.value = shuffled.take(6).toList();
  }

  void updateSearch(String q) {
    searchQuery.value = q;
    if (q.isEmpty) _setRandomProducts();
    else filterProducts();
  }

  void updatePriceRange(RangeValues r) {
    selectedRange.value = r;
    filterProducts();
  }

  void filterProducts() {
    final q     = searchQuery.value.trim().toLowerCase();
    final words = q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    products.value = allProducts.where((p) {
      final name      = p.productName.toLowerCase();
      final matches   = words.isEmpty || words.any((w) => name.contains(w));
      final inRange   = p.price >= selectedRange.value.start
          && p.price <= selectedRange.value.end;
      return matches && inRange;
    }).toList();
  }

  Future<UserData> getUserData() async {
    final ud = await client
        .from('user_data')
        .select()
        .eq('user_id', user.value.id);
    return UserData.fromJson((ud as List)[0]);
  }

  Future<void> logOut() async {
    await client.auth.signOut();
  }
}

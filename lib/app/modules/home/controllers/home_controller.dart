import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/userData.dart';
import '../../../data/models/productStock.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  late Rx<User> user;

  var allProducts = <ProductStock>[].obs;
  var products = <ProductStock>[].obs;
  var searchQuery = ''.obs;

  var showFilters = false.obs;
  var selectedExpansion = ''.obs; //TODO: Agregar expansiones
  var expansionOptions = <String>[].obs;

  var maxPrice = 1000.0.obs;
  var selectedPrice = 0.0.obs;

  @override
  void onInit() {
    User? currentUser = client.auth.currentUser;

    if (currentUser != null) {
      user = Rx<User>(client.auth.currentUser!);
      fetchProducts();
    }
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      var response = await client.from('product_stock').select();

      maxPrice.value = allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);
      selectedPrice.value = maxPrice.value;

      allProducts.value = response.map<ProductStock>((item) => ProductStock.fromJson(item)).toList();
      expansionOptions.value = allProducts.map((p) => p.expansionId.toString()).toSet().toList();
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
    showFilters.value = query.isNotEmpty;

    if (query.isEmpty) {
      _setRandomProducts();
    } else {
      filterProducts();
    }
  }

  void filterProducts() {
    var filtered = allProducts.where((p) =>
    p.productName.toLowerCase().contains(searchQuery.value.toLowerCase()) &&
        p.price <= selectedPrice.value
    );

    if (selectedExpansion.value.isNotEmpty) {
      filtered = filtered.where((p) => p.expansionId.toString() == selectedExpansion.value);
    }

    products.value = filtered.toList();
  }


  Future<UserData> getUserData() async {
    var userData = await client.from('user_data').select().eq('user_id', user.value.id);
    return UserData.fromJson(userData[0]);
  }

  Future<void> logOut() async {
    await client.auth.signOut();
  }
}

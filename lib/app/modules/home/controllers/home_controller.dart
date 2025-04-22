import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/userData.dart';
import '../../../data/models/productStock.dart';

//import 'package:themewstore/app/data/models/userData.dart';
//import 'package:themewstore/app/data/models/productStock.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  late Rx<User> user;
  var products = <ProductStock>[].obs;

  @override
  void onInit() {
    User? currentUser = client.auth.currentUser;

    if (currentUser != null) {
      user = Rx<User>(client.auth.currentUser!);
      fetchProducts();
    }
    super.onInit();
  }

  Future<UserData> getUserData() async {
    var userData =
        await client.from('user_data').select().eq('user_id', user.value.id);
    UserData userDataModel = UserData.fromJson(userData[0]);
    return userDataModel;
  }

  Future<void> fetchProducts() async {
    try {
      var response = await client.from('product_stock').select();

      products.value = response
          .map<ProductStock>((item) => ProductStock.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> logOut() async {
    await client.auth.signOut();
  }
}

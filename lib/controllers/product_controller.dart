import 'dart:convert';

import 'package:empulse/models/product.dart';
import 'package:empulse/models/product_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:get/state_manager.dart';

class ProductController extends GetxController {
  late List<Product> productTypes = [];

  Future<List<ProductModel>> getProductList(String filter) async {
    dynamic detailsList = <ProductModel>[];
    var data = {
      's': filter,
    };
    var response =
        await BaseClient().dioPost('/search-product', json.encode(data));
    if (response != null && response['success']) {
      List productsJson = response['data'];

      for (Map<String, dynamic> product in productsJson) {
        detailsList.add(ProductModel.fromJson(product));
      }
    }
    return detailsList.toList();
  }
}

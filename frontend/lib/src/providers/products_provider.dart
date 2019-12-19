import 'dart:convert';

import 'package:easy_cart/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:easy_cart/src/libs/constants.dart' as Constants;

const basePath = '${Constants.BACKEND_HOST}/api/';
const headers = {"Content-Type": "application/json"};

class ProductsProvider {
  static Future getProducts() async {
    final response = await http.get("${basePath}products");

    if (response.statusCode != 200) throw Exception('Failed to load products');

    Iterable list = json.decode(response.body);
    return list.map((model) => Product.fromJson(model)).toList();
  }

  static Future deleteProduct(String id) async {
    final response = await http.delete("${basePath}products/$id");

    if (response.statusCode != 200) throw Exception('Failed to delete product');

    return response.body;
  }

  static Future updateProduct(id, product) async {
    final response = await http.put("${basePath}products/$id",
        body: json.encode(product), headers: headers);

    if (response.statusCode != 200) throw Exception('Failed to update product');

    return json.decode(response.body);
  }

  static Future createProduct(product) async {
    final response = await http.post("${basePath}products",
        body: json.encode(product), headers: headers);

    if (response.statusCode != 201) throw Exception('Failed to create product');

    return json.decode(response.body);
  }

  static Future deleteAllProducts() async {
    final response = await http.delete("${basePath}products");

    if (response.statusCode != 200) throw Exception('Failed to delete product');

    return;
  }
}

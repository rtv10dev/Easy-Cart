import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/src/models/product_model.dart';
import 'package:easy_cart/src/providers/products_provider.dart';

class ProductsCheckPage extends StatefulWidget {
  final List<Product> products;

  ProductsCheckPage({Key key, this.products}) : super(key: key);

  @override
  _ProductsCheckPageState createState() => _ProductsCheckPageState();
}

class _ProductsCheckPageState extends State<ProductsCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView.separated(
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderList(index, context);
          },
          separatorBuilder: (context, index) =>
              Divider(height: 0, thickness: 0.5),
        ));
  }

  CheckboxListTile _renderList(index, ctx) {
    var product = widget.products[index];
    return CheckboxListTile(
      title: Text(product.name),
      value: product.checked,
      onChanged: (val) async {
        var updatedProduct = await _toggleProductCheck(product.id, val);
        updatedProduct = Product.fromJson(updatedProduct);
        setState(() {
          widget.products[index] = updatedProduct;
        });
      },
    );
  }

  _toggleProductCheck(id, value) async {
    var body = {'checked': value};
    var product = await ProductsProvider.updateProduct(id, body);
    return product;
  }
}

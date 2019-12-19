import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/src/models/product_model.dart';
import 'package:easy_cart/src/providers/products_provider.dart';
import 'package:easy_cart/src/utils/utils.dart';
import 'package:easy_cart/generated/custom_i18n.dart';

class ProductsListPage extends StatefulWidget {
  final List<Product> products;

  ProductsListPage({Key key, this.products}) : super(key: key);

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  List<Product> products;

  @override
  Widget build(BuildContext context) {
    products = widget.products;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView.separated(
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderList(index);
          },
          separatorBuilder: (context, index) =>
              Divider(height: 0, thickness: 0.5),
        ));
  }

  Dismissible _renderList(index) {
    var product = products[index];
    return Dismissible(
      confirmDismiss: (direction) async {
        return await _showDialog(index);
      },
      child: ListTile(
        trailing: Text(product.quantity.toString()),
        title: Text(product.name),
      ),
      key: ValueKey(index),
      background: Container(
        color: Colors.red[300],
        alignment: Alignment.centerRight,
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(index) {
    final String title = S.of(context).confirm;
    final String productName = products[index].name;
    final String body = S.of(context).deleteConfirmation(productName);
    final String cancel = S.of(context).cancel;
    final String delete = S.of(context).delete;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancel),
            ),
            FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  await _deleteProduct(index);
                },
                child: Text(delete)),
          ],
        );
      },
    );
  }

  _deleteProduct(index) async {
    try {
      await ProductsProvider.deleteProduct(products[index].id);
    } catch (err) {
      showErrorToast('Error deleting product');
    }
  }
}

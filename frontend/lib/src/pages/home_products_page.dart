import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/generated/custom_i18n.dart';
import 'package:easy_cart/src/models/product_model.dart';
import 'package:easy_cart/src/pages/dialogs/create_product_dialog.dart';
import 'package:easy_cart/src/pages/products_check_page.dart';
import 'package:easy_cart/src/pages/products_list_page.dart';
import 'package:easy_cart/src/providers/products_provider.dart';
import 'package:easy_cart/src/providers/push_notifications.dart';
import 'package:easy_cart/src/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomeProductsPage extends StatefulWidget {
  final PushNotificationsProvider pushProvider;
  HomeProductsPage({Key key, this.pushProvider}) : super(key: key);

  @override
  _HomeProductsPageState createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage>
    with WidgetsBindingObserver {
  List<Product> _products = new List<Product>();
  String _sortingOrder = 'ascending';
  int _currentIndex = 0;
  ProgressDialog _progressDialog;

  initState() {
    super.initState();
    _getProducts();

    WidgetsBinding.instance.addObserver(this);

    widget.pushProvider.messages.listen((info) {
      _getProducts();
    });
  }

  _askMicPermission() async {
    Map<PermissionGroup, PermissionStatus> permissionsStatus =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.microphone]);
    return permissionsStatus[PermissionGroup.microphone];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context);

    return Scaffold(
      body: _renderPage(_currentIndex),
      bottomNavigationBar: _renderBottomNavigationBar(),
      floatingActionButton: _renderFloatingActionButton(),
      appBar: _renderAppBar(),
    );
  }

  Widget _renderPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return ProductsListPage(
          products: _products,
        );
      case 1:
        return ProductsCheckPage(
          products: _products,
        );
      default:
        return ProductsListPage(
          products: _products,
        );
    }
  }

  Widget _renderAppBar() {
    final String title = S.of(context).productList;
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          onPressed: _sortList,
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.delete_sweep),
          onPressed: _deleteAll,
          color: Colors.white,
        )
      ],
    );
  }

  Widget _renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.list), title: Text(S.of(context).list)),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            title: Text(S.of(context).check))
      ],
    );
  }

  Widget _renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _createProduct();
      },
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  _getProducts() async {
    _showProgressDialog();
    var products = await ProductsProvider.getProducts();
    _hideProgressDialog();
    setState(() {
      _products = products;
    });
  }

  _sortList() {
    if (_sortingOrder == 'ascending') {
      _products.sort((a, b) => a.name.compareTo(b.name));
    } else {
      _products.sort((b, a) => a.name.compareTo(b.name));
    }

    setState(() {
      _sortingOrder = _sortingOrder == 'ascending' ? 'descending' : 'ascending';
    });
  }

  _showProgressDialog() {
    _progressDialog?.show();
  }

  _hideProgressDialog() {
    if (_progressDialog != null) {
      setState(() {
        Future.delayed(Duration(seconds: 1)).then((value) {
          _progressDialog.hide();
        });
      });
    }
  }

  _createProduct() async {
    var permissionStatus = await _askMicPermission();
    String permissionMessage = S.of(context).microphonePermission;

    if (permissionStatus != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
      _hideProgressDialog();
      showErrorToast(permissionMessage);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateProductDialog();
        },
      );
    }
  }

  _deleteAll() async {
    String title = S.of(context).confirm;
    String body = S.of(context).deleteConfirmationAll;
    String cancel = S.of(context).cancel;
    String delete = S.of(context).delete;
    String error = S.of(context).errorDeletingAll;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancel.toUpperCase()),
            ),
            FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  try {
                    await ProductsProvider.deleteAllProducts();
                  } catch (err) {
                    showErrorToast(error);
                  }
                },
                child: Text(delete.toUpperCase())),
          ],
        );
      },
    );
  }
}

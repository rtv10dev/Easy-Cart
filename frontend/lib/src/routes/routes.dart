import 'package:flutter/cupertino.dart';
import 'package:easy_cart/src/pages/home_products_page.dart';
import 'package:easy_cart/src/pages/register_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(pushProvider) {
  return <String, WidgetBuilder>{
    'register': (BuildContext context) => RegisterPage(),
    'products': (BuildContext context) =>
        HomeProductsPage(pushProvider: pushProvider),
  };
}

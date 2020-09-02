import 'package:flutter/material.dart';
import 'package:store/ui/screens/home_page.dart';
import 'package:store/ui/screens/search_tab.dart';
import 'package:store/ui/screens/shopping_cart_tab.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;
    //final BaseAuth auth = Provider.of<Auth>(context);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/search_tab':
        return MaterialPageRoute(builder: (_) => SearchTab());
      case '/shopping_cart_tab':
        return MaterialPageRoute(builder: (_) => ShoppingCartTab());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

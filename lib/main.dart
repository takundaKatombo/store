import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:store/model/app_state_model.dart';
import 'package:store/services/locator.dart';
import 'package:store/services/route_generator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateModel>(
        create: (BuildContext context) => AppStateModel()..loadProducts(),
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.red),
          initialRoute: '/',
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        ));
  }
}

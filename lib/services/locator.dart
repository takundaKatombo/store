import 'package:get_it/get_it.dart';
import 'package:store/model/app_state_model.dart';
import 'package:store/model/login_model.dart';
import 'package:store/services/auth.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => AppStateModel());
  locator.registerFactory(() => LogInModel());
  locator.registerFactory(() => Auth());

  //locator.registerFactory(() => HomeModel());
}

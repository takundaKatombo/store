import 'package:get_it/get_it.dart';
import 'package:store/model/app_state_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => AppStateModel());
  //locator.registerFactory(() => HomeModel());
}

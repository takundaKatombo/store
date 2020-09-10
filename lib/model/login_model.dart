import 'package:store/model/enums.dart';
import 'package:store/services/auth.dart';
import 'package:store/services/locator.dart';

class LogInModel {
  final Auth auth = locator<Auth>();
  bool success = false;

  String email;

  AuthStatus loginStatus = AuthStatus.NOT_LOGGED_IN;
  //FirebaseUser user;
  Future<bool> loginCallBack(String email, String password) async {
    var result = await auth.signIn(email, password);
    this.email = email;
    if (result != null) {
      success = true;
      loginStatus = AuthStatus.LOGGED_IN;
      this.email = email;
      //user = result;
      return success;
    } else
      loginStatus = AuthStatus.NOT_LOGGED_IN;
    return false;
  }

  Future<bool> signupCallBack(String email, String password) async {
    var result = await auth.signUp(email, password);
    if (result != null) {
      success = true;
      this.email = email;

      //user = result;
      loginStatus = AuthStatus.LOGGED_IN;
      return success;
    } else
      loginStatus = AuthStatus.NOT_LOGGED_IN;
    return false;
  }

  Future<void> signout() async {
    auth.signOut();
  }

  String getUser() {
    //var result = await auth.getCurrentUser();
    //String result = userResult.toString();
    return auth.email;
  }

  /*void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }*/
}

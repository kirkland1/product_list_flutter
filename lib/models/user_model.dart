
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  late String _token;

  void setToken(String token){
    _token = token;
    notifyListeners();
  }

  String getToken() {
    return _token;
  }

}
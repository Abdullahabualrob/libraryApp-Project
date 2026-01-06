import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {

  UserModel? _user;

  UserModel? get user => _user;

  bool get isAdmin => _user?.isAdmin ?? false;

  void setUser(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

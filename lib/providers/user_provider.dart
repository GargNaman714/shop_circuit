import 'package:flutter/cupertino.dart';
import 'package:shop_circuit/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User( //private variable of User
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      token: '',
      cart: [],
      );

      //since _user is a private variable, create a getter for this
      User get user=>_user;

      //creating a function to update user
      void setUser(String user) 
      {
        _user=User.fromJson(user);
        notifyListeners(); // notifying all the listeners that are user value is changed
      }

    void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}

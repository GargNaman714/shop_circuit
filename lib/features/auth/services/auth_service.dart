//contains all of the authentication part services
//connecting SignUp route with client side(frontend-flutter)

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_circuit/common/widgets/bottom_bar.dart';
import 'package:shop_circuit/constants/error_handling.dart';
import 'package:shop_circuit/constants/global_variables.dart';
import 'package:shop_circuit/constants/utils.dart';
import 'package:shop_circuit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shop_circuit/providers/user_provider.dart';

class AuthService {
  //sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    //async coz we r going to make http requests which return Futures
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse(
            '$uri/api/signup'), // since http.post accepts uri and not string, therefore to convert string to uri, use Uri.parse
        body: user
            .toJson(), //user ko Json format m convert kiya hai coz we have used a middleware in index.js file: app.use(express.json());
        headers: <String, String>{
          //ye add krni hi padegi everytime we make a request through api coz we have used a middleware in index.js file: app.use(express.json()); Isme samjhne jaise kuch nhi hai simmply copy paste krdo everytime
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    //async coz we r going to make http requests which return Futures
    try {
      //since we r not going to save any data to DB, therefore no need of making 'User'
      // User user = User(
      //   id: '',
      //   name: name,
      //   password: password,
      //   email: email,
      //   address: '',
      //   type: '',
      //   token: '',
      // );

      http.Response res = await http.post(
        Uri.parse(
            '$uri/api/signin'), // since http.post accepts uri and not string, therefore to convert string to uri, use Uri.parse
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          //ye add krni hi padegi everytime we make a request through api coz we have used a middleware in index.js file: app.use(express.json()); Isme samjhne jaise kuch nhi hai simmply copy paste krdo everytime
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res
              .body); //we always set 'listen' to false when we r outside the build function
          await prefs.setString(
              'x-auth-token',
              jsonDecode(res.body)[
                  'token']); //'x-auth-token' is just a key name which is mapped to value of token

          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//get user data
// once the user has signed-in, we should get its data by using "shared preferences" package so that he doesn't need to fill his details everytime he opens our app
  void getUserData(
    BuildContext context,
  ) async {
    //async coz we r going to make http requests which return Futures
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token ==
          null) // this means the user is using our app for the first time, hence jwt wont be able to return us any token regarding that user data
      {
        prefs.setString('x-auth-token', ''); // setting token to empty string
      }

      //now if token is non-null, we need to authorize that if the token is valid or not as it can be tampered by some hackers. For this, we need to create an api in auth.js. Name of the api: tokenIsValid
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsvalid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response=jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
      
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

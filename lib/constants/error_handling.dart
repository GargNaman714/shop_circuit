import 'dart:convert';

import 'package:shop_circuit/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context, // we need this when we want to show snackbar for an error
  required VoidCallback onSuccess, //VoidCallback == Function()?
}) {
  switch (response.statusCode) { // using switch-case format coz based on the statuscode, we are judging if we are having an error or warning or all OK
    case 200:  //200 status code means OK(execution successful)
      onSuccess();
      break;
    case 400: //400 status code is for bad request from client
      showSnackBar(context, jsonDecode(response.body)['msg']); // since response.body give a jSon response, first we need to decode it using jsonDecode() and then use its properties. Moreover, auth.js mein hm ek msg pass kr rhe hai aise: msg:" User with same email already exist!", issi wjh se yaha 'msg' likha hai
      break;
    case 500: //500 status code is when there is problem at server side 
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body); // for any other error, hm poora jSOn format hi dikha rhe hai snackbar m
  }
}
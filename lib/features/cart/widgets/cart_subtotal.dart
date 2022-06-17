import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_circuit/providers/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user; //context.watch() is shorthandd syntax of writing Provider.of(context). Jaise abhi tk likhte aae hai waise bhi likh sakte hai: final userProvider = Provider.of<UserProvider>(context, listen: false);
    int sum = 0;

    //this is in video--> 08:35:50
    //caculating total price of all the products present in the user's cart
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList(); //.toList()--> to conver it back to List, otherwise it wont do anything and remain as an iterable

//this regex is not in the video. Yeh stackoverflow se uthaya hai. This is to add commas in a number. EG; to dispay 12000 as 12,000.00
// stackoverflow link: https://stackoverflow.com/questions/31931257/dart-how-to-add-commas-to-a-string-number
String totalSum=sum.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$'+totalSum,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
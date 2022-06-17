import 'package:flutter/material.dart';
import 'package:shop_circuit/features/account/services/account_services.dart';
import 'package:shop_circuit/features/account/widgets/account_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

  final AccountServices accountServices=AccountServices();

    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: () {}),
            AccountButton(text: 'Turn Seller', onTap: () {}),
          ],
        ),
       const SizedBox(height: 10,),
        Row(
          children: [
            AccountButton(text: 'Your Wish List', onTap: () {}),
            AccountButton(text: 'Log Out', onTap:()=> accountServices.logOut(context)),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_circuit/common/widgets/loader.dart';
import 'package:shop_circuit/constants/global_variables.dart';
import 'package:shop_circuit/features/account/services/account_services.dart';
import 'package:shop_circuit/features/account/widgets/single_product.dart';
import 'package:shop_circuit/features/order_details/screens/order_details.dart';
import 'package:shop_circuit/models/order.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ),
                  ),
                ],
              ),
              //display orders using ListView Builder
              Container(
                height:
                    170, // imp to mention this otherwise render overflow error, OR we could have used Expanded Widget but that won't look good
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                  right: 0,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orders!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, OrderDetailScreen.routeName,arguments: orders![index]);
                      },
                      child: SingleProduct(
                          image: orders![index].products[0].images[0]),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

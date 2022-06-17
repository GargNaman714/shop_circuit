// this is going to be very simmilar to post screen

import 'package:flutter/material.dart';
import 'package:shop_circuit/features/admin/services/admin_services.dart';
import 'package:shop_circuit/models/order.dart';

import '../../../common/widgets/loader.dart';
import '../../account/widgets/single_product.dart';
import '../../order_details/screens/order_details.dart';

class OrdersScren extends StatefulWidget {
  const OrdersScren({Key? key}) : super(key: key);

  @override
  State<OrdersScren> createState() => _OrdersScrenState();
}

class _OrdersScrenState extends State<OrdersScren> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //this tells that atmost 2 items will be shown in a row of the grid
            ), //
            itemBuilder: (context, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailScreen.routeName,
                    arguments: orderData,
                  );
                },
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(
                    image: orderData.products[0].images[0],
                  ),
                ),
              );
            },
          );
  }
}

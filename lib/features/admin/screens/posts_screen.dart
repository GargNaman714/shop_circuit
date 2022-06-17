
//THIS SCREEN IS IN ADMIN PANEL

import 'package:flutter/material.dart';
import 'package:shop_circuit/common/widgets/loader.dart';
import 'package:shop_circuit/features/account/widgets/single_product.dart';
import 'package:shop_circuit/features/admin/screens/add_product_screen.dart';
import 'package:shop_circuit/features/admin/services/admin_services.dart';
import 'package:shop_circuit/models/product.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products; //nullable

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  // fetchAllProducts() async {
  //   products = await adminServices.fetchAllProducts(context: context, onSuccess: (){
  //     setState((){});
  //   });
  //   // setState(() {});
  // }
  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: productData.images[0],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: ()=>deleteProduct(productData, index),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: navigateToAddProduct,
              tooltip: 'Add a Product',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

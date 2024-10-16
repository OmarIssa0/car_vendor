import 'package:car_vendor/features/add_product/presentation/view/market_view.dart';
import 'package:car_vendor/features/auth/presentation/manger/provider/user_provider.dart';
import 'package:car_vendor/features/lang/app_localization.dart';
import 'package:car_vendor/features/my_product/presentation/view/widgets/item_products_vendor.dart';
import 'package:car_vendor/features/my_product/presentation/view_model/provider/my_products_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProductViewBody extends StatelessWidget {
  const MyProductViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorProductProvider = Provider.of<VendorProductsProvider>(context);
    vendorProductProvider.fetchMyProducts();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userModel = userProvider.userModel;

    return Consumer<VendorProductsProvider>(
      builder: (context, provider, child) {
        // final myProducts = provider.myProducts;
        return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:
                // myProducts.isEmpty
                //     ? const Center(child: Text("No Products Found"))
                //     :
                StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .where('vendorId', isEqualTo: userModel!.vendorId)
                  .snapshots(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(child: CircularProgressIndicator());
                // }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products available'));
                }

                final vendorDocs = snapshot.data!.docs;

                return Column(
                  children: List.generate(
                    vendorDocs.length,
                    (vendorIndex) {
                      var vendorData = vendorDocs[vendorIndex].data()
                          as Map<String, dynamic>;

                      if (!vendorData.containsKey('products')) {
                        return const ListTile(
                          title:
                              Text('Error: Missing products field in document'),
                        );
                      }

                      var productsList =
                          vendorData['products'] as List<dynamic>;

                      return productsList.isEmpty
                          ? Center(child: Text("No Products Found".tr(context)))
                          : Column(
                              children: List.generate(
                                productsList.length,
                                (productIndex) {
                                  var product = productsList[productIndex]
                                      as Map<String, dynamic>;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        MarkerView.routeName,
                                        arguments: product['productId'],
                                      );
                                    },
                                    child: ItemProductsVendor(
                                      image: product['productImage'][0] ?? '',
                                      description:
                                          product['productDescription'] ?? '',
                                      title: product['productTitle'] ?? '',
                                      price: product['productPrice'] ?? '',
                                      productId: product['productId'] ?? '',
                                    ),
                                  );
                                },
                              ).reversed.toList(),
                            );
                    },
                  ),
                );
              },
            ));
      },
    );
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/product.dart'; // Assuming you have a Product class defined in a separate file
import 'package:user/productdetail.dart'; // Assuming you have a ProductDetailScreen defined in a separate file

class ProductListScreen extends StatefulWidget {
  final int categoryId;

  ProductListScreen({required this.categoryId});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product>? allProducts;

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    try {
      final response = await http.post(Uri.parse('https://zoomfresh.co.in/api/productlist?category_id=${widget.categoryId}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        setState(() {
          allProducts = responseData.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchProductsByCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: (allProducts == null)
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allProducts?.length,
              itemBuilder: (context, index) {
                final product = allProducts?[index];
                return AnimatedOpacity(
                  opacity: product!.isAvailable ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: product,
                            categoryId: product.category_id,
                            onRefreshProductList: _refreshData,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.red),
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: 'https://zoomfresh.co.in/storage/' + product.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          'Price: ₹${product.variants.isNotEmpty ? product.variants[0].price : 'N/A'}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Callback method to refresh product list
  Future<void> _refreshData() async {
    await fetchProductsByCategory();
  }
}

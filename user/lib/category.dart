import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/productlist.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category>? allCategories;

  @override
  void initState() {
    super.initState();
    fetchCategoryList();
  }

  Future<void> fetchCategoryList() async {
    try {
      final response = await http.get(Uri.parse('https://zoomfresh.co.in/api/categorylist'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        setState(() {
          allCategories = responseData.map((item) => Category.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load category list');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Category'),
      ),
      body: (allCategories == null)
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allCategories?.length,
              itemBuilder: (context, index) {
                final category = allCategories?[index];
                return Container(
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.red),
                      ),
                      margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:CachedNetworkImage(
                          imageUrl: 'https://zoomfresh.co.in/storage/' + category!.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ), 
                    title: Text(category.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(categoryId: category.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;
  

  Category({required this.id, required this.name,required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image:json['image']
    
    );
  }
}

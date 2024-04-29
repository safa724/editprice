import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/product.dart';
import 'package:user/productlist.dart';

class ProductDetailScreen extends StatefulWidget {
  late final Product product;
  final int categoryId;

  ProductDetailScreen({required this.product, required this.categoryId, required Future<void> Function() onRefreshProductList});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isAvailable = true; // Initialize with the product's initial availability status

 @override
  void initState() {
    super.initState();
    // Ensure that isAvailable is correctly initialized
    isAvailable = widget.product.isAvailable;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Column(
        children: [
          // Availability Indicator and Toggle Button
          Container(
  padding: EdgeInsets.all(10),
  alignment: Alignment.centerLeft,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Row(
      children: [
        SizedBox(width: 10),
        Text(
          'Availability',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Spacer(), // Use Spacer to push the Switch to the right
       Switch(
  value: isAvailable,
  activeColor: Colors.green,
  onChanged: (value) {
    setState(() {
      isAvailable = value; // Update the isAvailable variable
    });
    _updateAvailabilityStatus(value);
  },
),
      ],
    ),
  ),
),
          Expanded(
            child: ListView.builder(
              itemCount: widget.product.variants.length ?? 0,
              itemBuilder: (context, index) {
                final variant = widget.product.variants[index];
                return AnimatedOpacity(
                  opacity: isAvailable ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                    ),
                    child: ListTile(
                      title: Text("Variant $index"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: ₹${variant.price.toString()}',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                          Text('Measurements: ${variant.measurement.toString()}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
           InkWell(
            onTap: isAvailable
                ? () {
                    _showEditPricePopup(context, widget.product);
                  }
                : null, // Disable onTap when availability is false
            child: Container(
              height: 50,
              width: 400,
              child: Center(
                child: Text(
                  'EDIT PRICE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Neutraface',
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.red : Colors.grey, // Change button color when disabled
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
void _updateAvailabilityStatus(bool isAvailable) async {
  final response = await http.post(
    Uri.parse('https://zoomfresh.co.in/api/productstatusupdate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'product_id': widget.product.id,
      'status': isAvailable ? '1' : '0', // '1' for enable, '0' for disable
    }),
  );

  if (response.statusCode == 200) {
    print('Product status updated successfully');
  } else {
    print('Failed to update product status. Response: ${response.body}');
  }
}

  void _showEditPricePopup(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPricePopup(product: product,categoryId: product.category_id);
      },
    );
  }
}

class EditPricePopup extends StatefulWidget {
  final Product product;
   final int categoryId;

  EditPricePopup({required this.product, required this.categoryId});

  @override
  _EditPricePopupState createState() => _EditPricePopupState();
}

class _EditPricePopupState extends State<EditPricePopup> {
  TextEditingController _priceController = TextEditingController();
  bool _isAdd = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Price'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter Price'),
          ),
          Row(
            children: [
              Radio(
                value: true,
                groupValue: _isAdd,
                onChanged: (bool? value) {
                  setState(() {
                    _isAdd = value!;
                  });
                },
              ),
              Text('Add'),
              Radio(
                value: false,
                groupValue: _isAdd,
                onChanged: (bool? value) {
                  setState(() {
                    _isAdd = value!;
                  });
                },
              ),
              Text('Subtract'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _editPrice();
         

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductListScreen(categoryId: widget.categoryId),)
);

          },
          child: Text('Edit Price'),
        ),
      ],
    );
  }

 void _editPrice() async {
  final double enteredPrice = double.tryParse(_priceController.text) ?? 0.0;
  final int multiplier = _isAdd ? 1 : 0;  // If _isAdd is true, multiplier is 1 (add), else 0 (subtract)

  print('Entered Price: $enteredPrice');
  print('Multiplier: $multiplier');

  // Assuming widget.product.id is the product ID
  await _updateProductPrice(widget.product.id, enteredPrice, multiplier);
}

 Future<void> _updateProductPrice(
    int productId, double enteredPrice, int multiplier) async {
  print('Updating price for product $productId');
  print('Entered Price: $enteredPrice');
  print('Multiplier: $multiplier');

  final response = await http.post(
    Uri.parse('https://zoomfresh.co.in/api/priceupdate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'id': productId,
      'price': enteredPrice.toString(),
      'type': multiplier.toString(),
    }),
  );

  if (response.statusCode == 200) {
    print('Prices updated successfully for product $productId');
  } else {
    print(
        'Failed to update prices for product $productId. Response: ${response.body}');
  }
}}

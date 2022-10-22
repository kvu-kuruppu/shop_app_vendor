import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductDetail extends StatefulWidget {
  final String id;
  final Map<String, dynamic> dataa;
  final List<dynamic> images;
  const ProductDetail({
    Key? key,
    required this.id,
    required this.dataa,
    required this.images,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _formkey = GlobalKey<FormState>();
  var productNameInput = TextEditingController();
  var brandInput = TextEditingController();
  var regularPriceInput = TextEditingController();
  var salesPriceInput = TextEditingController();
  var descriptionInput = TextEditingController();
  var skuInput = TextEditingController();
  var stockOnHandInput = TextEditingController();
  var reorderLevelInput = TextEditingController();
  var shippingChargeInput = TextEditingController();
  String? taxStatus;
  String? taxPercentage;
  bool? editable = true;

  Widget _taxStatusDrop() {
    return DropdownButtonFormField<String>(
      value: taxStatus,
      isExpanded: true,
      hint: const Text('Select Tax Status'),
      items: ['Taxable', 'Not Taxable']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          taxStatus = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Tax Status is required';
        }
      },
    );
  }

  Widget _taxPercentageDrop() {
    return DropdownButtonFormField<String>(
      value: taxPercentage,
      isExpanded: true,
      hint: const Text('Select Tax Percentage'),
      items:
          ['GST-10%', 'GST-12%'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          taxPercentage = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Tax Percentage is required';
        }
      },
    );
  }

  @override
  void initState() {
    setState(() {
      brandInput.text = widget.dataa['brand'] ?? 'Brand';
      productNameInput.text = widget.dataa['productName'];
      regularPriceInput.text = widget.dataa['regularPrice'].toString();
      salesPriceInput.text = widget.dataa['salesPrice'].toString();
      taxStatus = widget.dataa['taxStatus'];
      taxPercentage =
          widget.dataa['taxPercentage'] == 10 ? 'GST-10%' : 'GST-12%';
      descriptionInput.text = widget.dataa['description'];
      skuInput.text = widget.dataa['sku'] ?? 'SKU';
      stockOnHandInput.text = widget.dataa['stockOnHand'].toString();
      reorderLevelInput.text = widget.dataa['reorderLevel'].toString();
      shippingChargeInput.text = widget.dataa['shippingCharge'].toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 10, 11, 102),
        title: Text(widget.dataa['productName']),
      ),
      body: ListView(
        children: [
          // Images
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.images
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          width: 300,
                          child: CachedNetworkImage(
                            imageUrl: e,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          AbsorbPointer(
            absorbing: editable!,
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  // Brand
                  ProductFields(
                    textInput: brandInput,
                    text: 'Brand',
                  ),
                  // Product Name
                  ProductFields(
                      textInput: productNameInput, text: 'Product Name'),
                  // Description
                  ProductFields(
                      textInput: descriptionInput, text: 'Description'),
                  // Unit
                  if (widget.dataa['unit'] != null)
                    OnlyTextFields(widget: widget, text: 'Unit', field: 'unit'),
                  Row(
                    children: [
                      // Regular Price
                      Expanded(
                        child: ProductFields(
                          textInput: regularPriceInput,
                          keyboardType: TextInputType.number,
                          text: 'Regular Price',
                        ),
                      ),
                      // Sales Price
                      Expanded(
                        child: ProductFields(
                          textInput: salesPriceInput,
                          keyboardType: TextInputType.number,
                          text: 'Sales Price',
                        ),
                      ),
                    ],
                  ),
                  // Tax Status
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(child: _taxStatusDrop()),
                        const SizedBox(width: 20),
                        if (taxStatus == 'Taxable')
                          Expanded(child: _taxPercentageDrop()),
                      ],
                    ),
                  ),
                  // Category
                  OnlyTextFields(
                    widget: widget,
                    field: 'category',
                    text: 'Category',
                  ),
                  // Main Category
                  if (widget.dataa['mainCategory'] != null)
                    OnlyTextFields(
                      widget: widget,
                      field: 'mainCategory',
                      text: 'Main Category',
                    ),
                  // Sub Category
                  if (widget.dataa['subCategory'] != null)
                    OnlyTextFields(
                      widget: widget,
                      field: 'subCategory',
                      text: 'Sub Category',
                    ),
                  // SKU
                  if (widget.dataa['sku'] != null)
                    ProductFields(textInput: skuInput, text: 'SKU'),
                  if (widget.dataa['manageInventory'] == true)
                    Row(
                      children: [
                        // Stock on Hand
                        Expanded(
                          child: ProductFields(
                            textInput: stockOnHandInput,
                            text: 'Stock on Hand',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        // Reorder Level
                        Expanded(
                          child: ProductFields(
                            textInput: reorderLevelInput,
                            text: 'Reorder Level',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  // Shipping Charge
                  if (widget.dataa['shippingChargeStatus'] == true)
                    ProductFields(
                      textInput: shippingChargeInput,
                      text: 'Shipping Charge',
                      keyboardType: TextInputType.number,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: editable!
          ? FloatingActionButton(
              onPressed: () async {
                EasyLoading.show().then((value) {
                  setState(() {
                    editable = false;
                  });
                }).then((value) => EasyLoading.showToast(
                      'You can edit now',
                      duration: const Duration(seconds: 1),
                    ));
              },
              child: const Icon(Icons.edit),
            )
          : FloatingActionButton(
              onPressed: () {
                EasyLoading.show().then((value) {
                  setState(() {
                    editable = true;
                  });
                }).then((value) => EasyLoading.dismiss());
              },
              child: const Icon(Icons.save),
            ),
    );
  }
}

class OnlyTextFields extends StatelessWidget {
  const OnlyTextFields({
    Key? key,
    required this.widget,
    required this.text,
    required this.field,
  }) : super(key: key);

  final ProductDetail widget;
  final String text;
  final String field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$text :',
              style: const TextStyle(fontSize: 17),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              widget.dataa[field],
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductFields extends StatelessWidget {
  const ProductFields({
    Key? key,
    required this.textInput,
    required this.text,
    this.keyboardType,
  }) : super(key: key);

  final TextEditingController textInput;
  final String text;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('$text :', style: const TextStyle(fontSize: 17)),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: textInput,
              keyboardType: keyboardType,
              validator: (value) {
                if (value!.isEmpty) {
                  return '$text is required';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

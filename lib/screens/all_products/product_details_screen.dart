import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

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
  var remarksInput = TextEditingController();
  String? taxStatus;
  String? taxPercentage;
  bool? editable = true;
  DateTime? scheduleDate;
  bool? manageInventory = false;
  bool? shippingChargeStatus = false;
  List sizeList = [];

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
        return null;
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
        return null;
      },
    );
  }

  @override
  void initState() {
    setState(() {
      // General
      productNameInput.text = widget.dataa['productName'];
      descriptionInput.text = widget.dataa['description'];
      regularPriceInput.text = widget.dataa['regularPrice'].toString();
      salesPriceInput.text = widget.dataa['salesPrice'].toString();
      if (widget.dataa['scheduleDate'] != null) {
        scheduleDate = (widget.dataa['scheduleDate'] as Timestamp).toDate();
      }
      taxStatus = widget.dataa['taxStatus'];
      taxPercentage =
          widget.dataa['taxPercentage'] == 10 ? 'GST-10%' : 'GST-12%';

      // Inventory
      skuInput.text = widget.dataa['sku'] ?? 'SKU';
      if (widget.dataa['manageInventory'] == true) {
        manageInventory = widget.dataa['manageInventory'];
      }
      if (widget.dataa['stockOnHand'] != null) {
        stockOnHandInput.text = widget.dataa['stockOnHand'].toString();
      }
      if (widget.dataa['reorderLevel'] != null) {
        reorderLevelInput.text = widget.dataa['reorderLevel'].toString();
      }

      // Shipping
      if (widget.dataa['shippingChargeStatus'] == true) {
        shippingChargeStatus = widget.dataa['shippingChargeStatus'];
      }
      if (widget.dataa['shippingCharge'] != null) {
        shippingChargeInput.text = widget.dataa['shippingCharge'].toString();
      }

      // Attributes
      brandInput.text = widget.dataa['brand'];
      remarksInput.text = widget.dataa['remarks'];
      if (widget.dataa['sizeList'] != null) {
        sizeList = widget.dataa['sizeList'] as List;
      }
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
        actions: [
          editable!
              ? IconButton(
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
                  icon: const Icon(Icons.edit),
                )
              : IconButton(
                  onPressed: () {
                    EasyLoading.show().then((value) {
                      setState(() {
                        editable = true;
                      });
                    }).then((value) => EasyLoading.dismiss());
                  },
                  icon: const Icon(Icons.save),
                )
        ],
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
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
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
          AbsorbPointer(
            absorbing: editable!,
            child: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
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
                      textInput: descriptionInput,
                      text: 'Description',
                      minLines: 1,
                      maxLines: 10,
                    ),
                    // Remarks
                    ProductFields(
                      textInput: remarksInput,
                      text: 'Remarks',
                      minLines: 1,
                      maxLines: 10,
                    ),
                    // Unit
                    if (widget.dataa['unit'] != null)
                      OnlyTextFields(
                          widget: widget, text: 'Unit', field: 'unit'),
                    const Divider(color: Colors.black),
                    Column(
                      children: [
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
                            const SizedBox(width: 15),
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
                        if (scheduleDate != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Schedule Date
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Sales Price until: ',
                                  ),
                                  Text(
                                    DateFormat.yMd().format(scheduleDate!),
                                  ),
                                ],
                              ),
                              // Change Date Button
                              if (!editable!)
                                ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2999),
                                    ).then((value) {
                                      setState(() {
                                        scheduleDate = value;
                                      });
                                    });
                                  },
                                  child: const Text('Change Date'),
                                )
                            ],
                          ),
                      ],
                    ),
                    const Divider(color: Colors.black),
                    // Size List
                    if (sizeList.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Size List:',
                                  style: TextStyle(fontSize: 17)),
                              if (sizeList.isNotEmpty)
                                SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: sizeList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.orange[200],
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Center(
                                            child: Text(sizeList[index]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                        ],
                      ),
                    // Tax Status
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          Expanded(child: _taxStatusDrop()),
                          const SizedBox(width: 20),
                          if (taxStatus == 'Taxable')
                            Expanded(child: _taxPercentageDrop()),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
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
                    const Divider(color: Colors.black),
                    // SKU
                    if (widget.dataa['sku'] != null)
                      ProductFields(textInput: skuInput, text: 'SKU'),
                    const Divider(color: Colors.black),
                    // Manage Inventory?
                    Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Manage Inventory?'),
                          value: manageInventory,
                          onChanged: (value) {
                            setState(() {
                              manageInventory = value;
                              if (value == false || value == null) {
                                stockOnHandInput.clear();
                                reorderLevelInput.clear();
                              }
                            });
                          },
                        ),
                        if (manageInventory!)
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
                              const SizedBox(width: 15),
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
                      ],
                    ),
                    const Divider(color: Colors.black),
                    // Adding Shipping Charges?
                    Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Adding Shipping Charges?'),
                          value: shippingChargeStatus,
                          onChanged: (value) {
                            setState(() {
                              shippingChargeStatus = value;
                              if (value == false || value == null) {
                                shippingChargeInput.clear();
                              }
                            });
                          },
                        ),
                        // Shipping Charge
                        if (shippingChargeStatus!)
                          ProductFields(
                            textInput: shippingChargeInput,
                            text: 'Shipping Charge',
                            keyboardType: TextInputType.number,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 18),
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
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  final TextEditingController textInput;
  final String text;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
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
              minLines: minLines,
              maxLines: maxLines,
              validator: (value) {
                if (value!.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:shop_app_vendor/widgets/add_products/buttons.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';
import 'package:shop_app_vendor/widgets/scaffold_msg.dart';

class GeneralTab extends StatefulWidget {
  final VoidCallback onNext;

  const GeneralTab({Key? key, required this.onNext}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseService _service = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final SCF _scf = SCF();
  List<String> categoriesList = [];
  String? _selectedCategory;
  String? _taxStatus;
  String? _taxPercentage;
  bool _salesPrice = false;

  Widget _categoryDrop(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Select Category'),
      items: categoriesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedCategory = value;
          provider.getFormData(category: value);
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select Category is required';
        }
        return null;
      },
    );
  }

  Widget _taxStatusDrop(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: _taxStatus,
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
          _taxStatus = value;
          provider.getFormData(taxStatus: value);
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

  Widget _taxPercentageDrop(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: _taxPercentage,
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
          _taxPercentage = value;
          provider.getFormData(
              taxPercentage: _taxPercentage == 'GST-10%' ? 10 : 12);
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
    getCategories();
    super.initState();
  }

  getCategories() {
    _service.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          categoriesList.add(element['categoryName']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                // Product Name
                FormFieldInput(
                  label: 'Product Name',
                  onChanged: (value) {
                    provider.getFormData(productName: value);
                  },
                  maxLines: 1,
                ),
                // Description
                FormFieldInput(
                  label: 'Description',
                  inputType: TextInputType.multiline,
                  onChanged: (value) {
                    provider.getFormData(description: value);
                  },
                  minLines: 2,
                  maxLines: 10,
                ),
                // Category
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                  child: _categoryDrop(provider),
                ),
                // Main Category
                if (_selectedCategory != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return MainCategoryList(
                              selectedCategory: _selectedCategory,
                              provider: provider,
                            );
                          },
                        ).whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provider.productData!['mainCategory'] ??
                                    'Select Main Category',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                            ],
                          ),
                          const Divider(color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                // Sub Category
                if (provider.productData!['mainCategory'] != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SubCategoryList(
                              selectedMainCategory:
                                  provider.productData!['mainCategory'],
                              provider: provider,
                            );
                          },
                        ).whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provider.productData!['subCategory'] ??
                                    'Select Sub Category',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                            ],
                          ),
                          const Divider(color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                // Regular Price
                FormFieldInput(
                  label: 'Regular Price',
                  suffixIcon: Icons.monetization_on,
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      provider.getFormData(regularPrice: int.parse(value));
                    }
                  },
                ),
                // Sales Price
                FormFieldInput(
                    label: 'Sales Price',
                    suffixIcon: Icons.monetization_on,
                    inputType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (int.parse(value) >
                            provider.productData!['regularPrice']) {
                          _scf.scaffoldMsg(
                            context: context,
                            msg:
                                'Sales price should be less than Regular price',
                          );
                          return;
                        }
                        setState(() {
                          provider.getFormData(salesPrice: int.parse(value));
                          _salesPrice = true;
                        });
                      }
                    }),
                const SizedBox(height: 10),
                // Schedule
                if (_salesPrice)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2999),
                          ).then((value) {
                            setState(() {
                              provider.getFormData(scheduleDate: value);
                            });
                          });
                        },
                        child: const Text(
                          'Schedule',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      if (provider.productData!['scheduleDate'] != null)
                        Text(DateFormat.yMd()
                            .format(provider.productData!['scheduleDate']))
                    ],
                  ),
                // Tax Status
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                  child: _taxStatusDrop(provider),
                ),
                // Tax Percentage
                if (_taxStatus == 'Taxable')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                    child: _taxPercentageDrop(provider),
                  ),
              ],
            ),
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onNext();
                  }
                },
                text: 'Next',
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainCategoryList extends StatelessWidget {
  final String? selectedCategory;
  final ProductProvider? provider;

  const MainCategoryList({
    Key? key,
    this.selectedCategory,
    this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();

    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: service.mainCategory
            .where('category', isEqualTo: selectedCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data!.size == 0) {
            return const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text('No Main Categories')),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data!.docs[index]['mainCategory']),
                onTap: () {
                  provider!.getFormData(
                    mainCategory: snapshot.data!.docs[index]['mainCategory'],
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String? selectedMainCategory;
  final ProductProvider? provider;

  const SubCategoryList({
    Key? key,
    this.selectedMainCategory,
    this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();

    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: service.subCategory
            .where('mainCategoryName', isEqualTo: selectedMainCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data!.size == 0) {
            return const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text('No Main Categories')),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data!.docs[index]['subCategoryName']),
                onTap: () {
                  provider!.getFormData(
                    subCategory: snapshot.data!.docs[index]['subCategoryName'],
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
    );
  }
}

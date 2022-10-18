import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseService _service = FirebaseService();
  List<String> categoriesList = [];
  final _formkey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _taxStatus;
  String? _taxPercentage;

  Widget _formField({
    String? label,
    TextInputType? inputType,
    void Function(String)? onChanged,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
        suffixIcon: Icon(suffixIcon),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label is required';
        }
      },
      onChanged: onChanged,
    );
  }

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
      validator: (value) => 'Tax Status is required',
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
      validator: (value) => 'Tax Percentage is required',
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
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formkey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              // Product Name
              _formField(
                label: 'Product Name',
                onChanged: (value) {
                  provider.getFormData(productName: value);
                },
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
              _formField(
                label: 'Regular Price',
                suffixIcon: Icons.monetization_on,
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(regularPrice: int.parse(value));
                },
              ),
              // Sales Price
              _formField(
                label: 'Sales Price',
                suffixIcon: Icons.monetization_on,
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(salesPrice: int.parse(value));
                },
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
    final FirebaseService _service = FirebaseService();

    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.mainCategory
            .where('category', isEqualTo: selectedCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No Main Categories'));
          }

          return ListView.builder(
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
    final FirebaseService _service = FirebaseService();

    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.subCategory
            .where('mainCategoryName', isEqualTo: selectedMainCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No Sub Categories'));
          }

          return ListView.builder(
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

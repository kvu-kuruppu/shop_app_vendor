import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/buttons.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';

class InventoryTab extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const InventoryTab({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  bool? manageInventory = false;

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
                // SKU
                FormFieldInput(
                  label: 'SKU',
                  onChanged: (value) {
                    provider.getFormData(sku: value);
                  },
                  maxLines: 1,
                ),
                // Manage Inventory?
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Manage Inventory?'),
                  value: manageInventory,
                  onChanged: (value) {
                    setState(() {
                      manageInventory = value;
                      provider.getFormData(manageInventory: value);
                    });
                  },
                ),
                if (manageInventory == true)
                  Column(
                    children: [
                      // Stock on hand
                      FormFieldInput(
                        label: 'Stock on hand',
                        inputType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            provider.getFormData(stockOnHand: int.parse(value));
                          }
                        },
                      ),
                      // Reorder Level
                      FormFieldInput(
                        label: 'Reorder Level',
                        inputType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            provider.getFormData(
                                reorderLevel: int.parse(value));
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(
                    onPressed: () => widget.onPrevious(),
                    text: 'Previous',
                  ),
                  ActionButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onNext();
                      }
                    },
                    text: 'Next',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

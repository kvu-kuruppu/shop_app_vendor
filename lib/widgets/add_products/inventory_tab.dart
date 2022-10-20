import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? manageInventory = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return ListView(
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
                      provider.getFormData(stockOnHand: int.parse(value));
                    },
                  ),
                  // Reorder Level
                  FormFieldInput(
                    label: 'Reorder Level',
                    inputType: TextInputType.number,
                    onChanged: (value) {
                      provider.getFormData(reorderLevel: int.parse(value));
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

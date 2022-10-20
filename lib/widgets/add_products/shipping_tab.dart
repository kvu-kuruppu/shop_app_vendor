import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? shippingChargeStatus = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            // Shipping Charge Status
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Adding Shipping Chargers?'),
              value: shippingChargeStatus,
              onChanged: (value) {
                setState(() {
                  shippingChargeStatus = value;
                  provider.getFormData(shippingChargeStatus: value);
                });
              },
            ),
            // Shipping Charges
            if (shippingChargeStatus == true)
              FormFieldInput(
                label: 'Shipping Charges',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(shippingCharge: int.parse(value));
                },
              ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/buttons.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';

class ShippingTab extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const ShippingTab({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  bool? shippingChargeStatus = false;

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
                      if (value.isNotEmpty) {
                        provider.getFormData(shippingCharge: int.parse(value));
                      }
                    },
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
                  // Previous Button
                  ActionButton(
                    onPressed: () => widget.onPrevious(),
                    text: 'Previous',
                  ),
                  // Next Button
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

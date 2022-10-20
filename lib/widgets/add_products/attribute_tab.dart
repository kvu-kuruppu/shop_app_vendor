import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/form_field_input.dart';

class AttributeTab extends StatefulWidget {
  const AttributeTab({Key? key}) : super(key: key);

  @override
  State<AttributeTab> createState() => _AttributeTabState();
}

class _AttributeTabState extends State<AttributeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<String> _sizeList = [];
  final _sizeInput = TextEditingController();
  bool saved = false;
  bool entered = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            // Brand
            FormFieldInput(
              label: 'Brand',
              onChanged: (value) {
                provider.getFormData(brand: value);
              },
              maxLines: 1,
            ),
            Row(
              children: [
                // Size
                Expanded(
                  child: TextFormField(
                    controller: _sizeInput,
                    decoration: const InputDecoration(
                      label: Text('Size'),
                    ),
                    maxLines: 1,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          entered = true;
                        });
                      }
                    },
                  ),
                ),
                // Add Button
                if (entered)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sizeList.add(_sizeInput.text);
                        _sizeInput.clear();
                        entered = false;
                        provider.getFormData(sizeList: _sizeList);
                      });
                    },
                    child: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Size List
            if (_sizeList.isNotEmpty)
              SizedBox(
                height: 50,
                width: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _sizeList.removeAt(index);
                            provider.getFormData(sizeList: _sizeList);
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(_sizeList[index].toUpperCase())),
                        ),
                      ),
                    );
                  },
                ),
              ),
            // * Tap to delete
            if (_sizeList.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '* Tap to delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            // Remarks
            FormFieldInput(
              label: 'Remarks',
              maxLines: 2,
              onChanged: (value) {
                provider.getFormData(remarks: value);
              },
            ),
          ],
        );
      },
    );
  }
}

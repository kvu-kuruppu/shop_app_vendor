import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/buttons.dart';

class ImagesTab extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const ImagesTab({
    Key? key,
    required this.onPrevious,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker _picker = ImagePicker();
  // List<XFile>? imageFiles = [];

  Future<List<XFile>?> pickImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              // Add Product Image
              TextButton(
                onPressed: () {
                  pickImage().then((value) {
                    value!.forEach((image) {
                      setState(() {
                        provider.getImageFiles(image);
                      });
                    });
                  });
                },
                child: const Text('Add Product Image(s)'),
              ),
              // Image List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '(* Tap to delete)',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.imageFiles!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 200,
                          width: 200,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                provider.imageFiles!.removeAt(index);
                              });
                            },
                            child: provider.imageFiles == null
                                ? const Center(
                                    child: Text('No images selected'))
                                : Image.file(
                                    File(provider.imageFiles![index].path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
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
                    onPressed: () => widget.onSubmit(),
                    text: 'Submit',
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

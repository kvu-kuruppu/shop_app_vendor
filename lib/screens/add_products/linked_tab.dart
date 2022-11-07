import 'package:flutter/material.dart';
import 'package:shop_app_vendor/widgets/add_products/buttons.dart';

class LinkedTab extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const LinkedTab({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<LinkedTab> createState() => _LinkedTabState();
}

class _LinkedTabState extends State<LinkedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Linked Products')),
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
                onPressed: () => widget.onNext(),
                text: 'Next',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FormFieldInput extends StatelessWidget {
  final String? label;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final IconData? suffixIcon;
  final int? minLines;
  final int? maxLines;

  const FormFieldInput({
    Key? key,
    this.label,
    this.inputType,
    this.onChanged,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        return null;
      },
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
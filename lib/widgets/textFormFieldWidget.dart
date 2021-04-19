import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String fieldlabelText;
  final IconData prefixIconData;
  final Function onChangeField;
  final bool obscureText;
  final Function validate;
  final int maxLine;
  final TextInputType inputType;
  final controller;
  const TextFormFieldWidget(
      {this.fieldlabelText,
      this.prefixIconData,
      this.onChangeField,
      this.obscureText = false,
      this.validate,
      this.maxLine,
      this.inputType,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChangeField,
      obscureText: obscureText,
      validator: validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLine,
      autocorrect: true,
      keyboardType: inputType,
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        labelText: fieldlabelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
        ),
        focusColor: Theme.of(context).primaryColor,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}

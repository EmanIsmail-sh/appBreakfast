import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  Function onChanged;
  String labelText, hintText ,initialValue;
  Color color, backTextColor;
   TextInputType inputType;
TextEditingController textController;
   bool enabled;
  CustomTextFormField(
      {@required this.onChanged,
      @required this.labelText,
      @required this.hintText,
      @required this.color,
      @required this.backTextColor ,this.initialValue,this.inputType,this.enabled,this.textController});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          initialValue: initialValue,
          controller: textController,
          keyboardType: inputType,
          enabled: enabled,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            
            fillColor: backTextColor,
            filled: true,
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20),
            ),

            ///error border
            border: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

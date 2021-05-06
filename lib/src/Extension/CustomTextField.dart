import 'package:flutter/material.dart';
import 'package:video_share/src/Extension/Style.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    Key key,
    @required this.controller,
    @required this.labeltext,
    @required this.validator,
    this.inputType = TextInputType.text,
    this.isSecure = false,
    @required this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final String labeltext;
  final TextInputType inputType;
  final bool isSecure;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: labeltext,
          labelStyle: googleFont(size: 14),
          hintStyle: googleFont(size: 14),
        ),
        cursorColor: Colors.white,
        style: googleFont(size: 14),
        keyboardType: inputType,
        validator: validator,
        onChanged: onChange,
        obscureText: isSecure);
  }
}

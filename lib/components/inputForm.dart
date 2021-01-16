import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final dynamic textColor;
  final Color hintColor;
  final Color iconColor;

  InputForm({
    this.title,
    this.icon,
    this.controller,
    this.keyboardType,
    this.textColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: inputForm(
        title: title,
        icon: icon,
        controller: controller,
        keyboardType: keyboardType,
        textColor: textColor,
        hintColor: hintColor,
        iconColor: iconColor,
      ),
    );
  }

  TextFormField inputForm({
    String title,
    IconData icon,
    controller,
    TextInputType keyboardType,
    Color textColor,
    Color hintColor,
    Color iconColor,
  }) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        icon: Icon(
          icon,
          color: iconColor,
        ),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de $title';
        }
        return null;
      },
    );
  }
}

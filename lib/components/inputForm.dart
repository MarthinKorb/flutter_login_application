import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final dynamic textColor;
  final Color hintColor;
  final Color iconColor;
  final IconData suffixIcon;
  final String initialValue;

  final bool isPasswordType;

  InputForm({
    this.title,
    this.icon,
    this.controller,
    this.keyboardType,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.suffixIcon,
    this.isPasswordType = false,
    this.initialValue,
  });

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _obscureText = true;
  bool isPasswordType;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: inputForm(
        title: widget.title,
        icon: widget.icon,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textColor: widget.textColor,
        hintColor: widget.hintColor,
        iconColor: widget.iconColor,
        suffixIcon: widget.suffixIcon,
        isPasswordType: widget.isPasswordType,
        initialValue: widget.initialValue,
      ),
    );
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextFormField inputForm({
    String title,
    IconData icon,
    controller,
    TextInputType keyboardType,
    Color textColor,
    Color hintColor,
    Color iconColor,
    IconData suffixIcon,
    bool isPasswordType = false,
    String initialValue,
  }) {
    return !isPasswordType
        ? TextFormField(
            textInputAction: TextInputAction.next,
            controller: controller,
            style: TextStyle(color: textColor),
            initialValue: initialValue,
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
          )
        : TextFormField(
            textInputAction: TextInputAction.next,
            controller: controller,
            style: TextStyle(color: textColor),
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: title,
              hintStyle: TextStyle(
                color: hintColor,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  toggleObscureText();
                },
                child: _obscureText
                    ? Icon(suffixIcon)
                    : Icon(Icons.visibility_off_outlined),
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

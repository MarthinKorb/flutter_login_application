import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;

  InputForm(this.title, this.icon, this.controller);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: inputForm(title, icon, controller),
    );
  }

  TextFormField inputForm(String title, IconData icon, controller) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      style: TextStyle(color: Colors.deepPurple[500]),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(
          color: Colors.deepPurple[300],
        ),
        icon: Icon(
          icon,
          color: Colors.deepPurple[300],
        ),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de $title';
        }
        return null;
      },
    );
  }
}

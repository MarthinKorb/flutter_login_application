import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/inputForm.dart';
import 'package:flutter_login_application/services/product_service.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  SharedPreferences sharedPreferences;
  String _idUser;

  getUserIdFromSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('id') != null) {
      setState(() {
        _idUser = sharedPreferences.getString('id');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserIdFromSharedPref();
  }

  final _formKey = GlobalKey<FormState>();

  final descriptionController = TextEditingController();

  var productServices = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                InputForm(
                  'Descrição',
                  Icons.description,
                  descriptionController,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(50),
                      width: 200,
                      child: RaisedButton(
                        splashColor: Theme.of(context).splashColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 10,
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          final description = descriptionController.text;

                          Map data = {
                            "description": description,
                            "user_id": _idUser,
                          };
                          var body = jsonEncode(data);

                          if (_formKey.currentState.validate()) {
                            var resp = await productServices.createProduct(
                              Constants.HOST + '/products',
                              body,
                              Constants.CONTENT_TYPE,
                            );
                            print(resp.statusCode);
                            if (resp.statusCode == 201) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Produto cadastrado com sucesso')));
                              descriptionController.clear();
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Erro ao fazer o cadastro.')));
                              descriptionController.clear();
                            }
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Preencha os campos solicitados'),
                              ),
                            );
                          }
                        },
                        textColor: Theme.of(context).accentColor,
                        child: Text(
                          'Salvar',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

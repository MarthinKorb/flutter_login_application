import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/product_card.dart';
import 'package:flutter_login_application/models/product.dart';
import 'package:flutter_login_application/services/product_service.dart';
import 'package:flutter_login_application/services/user_services.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'package:flutter_login_application/utils/theme_color.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
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

  List<Product> _listProducts = List();

  var productService = ProductService();

  Future<List<Product>> _getProducts() async {
    var token = sharedPreferences.getString('token');
    var response = await productService.getProducts(
      idUser: _idUser,
      headers: {Constants.AUTHORIZATION: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      _listProducts.clear();
      var decodeJSON = jsonDecode(response.body);

      decodeJSON.forEach((item) => _listProducts.add(Product.fromMap(item)));

      return _listProducts;
    }
    if (response.statusCode == 401) {
      var userService = UserServices();
      await userService.login();
    } else {
      print('Erro ao carregar lista!');
      return null;
    }
    return null;
  }

  _showSnackBar({String message, context}) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<Response> _updateProduct(String id,
      {dynamic body, Map<String, String> headers}) async {
    var resp = await productService.updateProduct(id, body, headers);
    print(resp.body);
    if (resp.statusCode == 200) {
      _showSnackBar(
          context: context, message: 'Produto atualizado com sucesso!');
      Navigator.pop(context);
    } else {
      _showSnackBar(
          context: context, message: 'Erro ao realizar a atualização');
    }
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<Product>>(
          future: _getProducts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar a lista.'),
              );
            }
            List<Product> productList = snapshot.data;

            return productList.isNotEmpty
                ? RefreshIndicator(
                    child: ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                          key: Key(_listProducts[index].id.toString()),
                          child: ProductCard(_listProducts[index]),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_outlined,
                                                  color:
                                                      ThemeColor.warningColor,
                                                  size: 30,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                  ),
                                                  child: Text(
                                                    'Aviso',
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Você tem certeza que deseja deletar o produto ${_listProducts[index].description}?",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Deletar",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            var token = sharedPreferences
                                                .getString('token');
                                            var response = await productService
                                                .removeProduct(
                                              id: _listProducts[index]
                                                  .id
                                                  .toString(),
                                              headers: {
                                                Constants.AUTHORIZATION:
                                                    'Bearer $token'
                                              },
                                            );
                                            print(response.statusCode);
                                            if (response.statusCode == 200) {
                                              setState(() {
                                                _listProducts.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                            } else {
                              return _editProductModal(_listProducts[index]);
                            }
                          },
                        );
                      },
                    ),
                    onRefresh: () async {
                      _listProducts.clear();
                      await _getProducts();
                    },
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nenhum produto cadastrado",
                          style: TextStyle(
                            fontSize: 20,
                            color: ThemeColor.unselectedIcons,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.emoji_people_outlined,
                          size: 50,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Container(
        margin: const EdgeInsets.only(top: 2.0),
        color: ThemeColor.containerColor[100],
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: ThemeColor.containerColor,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  color: ThemeColor.containerColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
      child: Container(
        margin: const EdgeInsets.only(top: 2.0),
        color: ThemeColor.errorColor[200],
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: ThemeColor.errorColor[900],
              ),
              Text(
                "Deletar",
                style: TextStyle(
                  color: ThemeColor.errorColor[900],
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  _editProductModal(Product product) {
    final _formKey = GlobalKey<FormState>();
    final editingProductController =
        TextEditingController(text: product.description);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: Row(
              children: [
                Icon(Icons.edit, color: ThemeColor.unselectedIcons),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Editar produto',
                  style: TextStyle(color: ThemeColor.unselectedIcons),
                ),
              ],
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editingProductController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeColor.primaryColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var token = sharedPreferences.getString('token');
                      Map data = {
                        "description": editingProductController.text,
                      };
                      var encodedJsonBody = jsonEncode(data);
                      await _updateProduct(
                        product.id,
                        body: encodedJsonBody,
                        headers: {
                          Constants.AUTHORIZATION: 'Bearer $token',
                          "Content-Type": "application/json",
                        },
                      );
                    },
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

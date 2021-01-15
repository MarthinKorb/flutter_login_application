import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_application/models/product.dart';
import 'package:flutter_login_application/services/product_service.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsList extends StatefulWidget {
  final List<dynamic> products;

  ProductsList({this.products});

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
    var response = await http.get(
      Constants.HOST + '/products/$_idUser',
      headers: Constants.CONTENT_TYPE,
    );
    print(Constants.HOST + '/products/' + _idUser);
    print(response.body);
    if (response.statusCode == 200) {
      _listProducts.clear();
      var decodeJSON = jsonDecode(response.body);

      decodeJSON.forEach((item) => _listProducts.add(Product.fromMap(item)));

      return _listProducts;
    } else {
      print('Erro ao carregar lista!');
      return null;
    }
  }

  _showSnackBar({String message, context}) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Product>>(
        future: _getProducts(),
        // future: Provider.of<EntityProvider>(context, listen: false).loadList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
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
                        child: Card(
                          color: Colors.deepPurple,
                          child: ListTile(
                            leading: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {},
                              child: Container(
                                width: 48,
                                height: 48,
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple[200],
                                ),
                              ),
                            ),
                            title: Text(_listProducts[index].description),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        "Você tem certeza que deseja deletar o produto ${_listProducts[index].description}?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          var response = await productService
                                              .removeProduct(
                                            _listProducts[index].id.toString(),
                                          );

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
                            // TODO: Navigate to edit page;
                            return false;
                          }
                        },
                        onDismissed: (direction) {
                          productService.removeProduct(
                              _listProducts[index].id.toString());
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
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Icon(
                        Icons.warning_outlined,
                        size: 70,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget slideRightBackground() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        color: Colors.deepPurple[200],
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.deepPurple,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        color: Colors.red[200],
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.red[600],
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w700,
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
}

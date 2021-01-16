import 'package:flutter/material.dart';
import 'package:flutter_login_application/utils/theme_color.dart';

class ProductCard extends StatelessWidget {
  final _product;

  ProductCard(this._product);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
        color: ThemeColor.secundaryColor,
        child: ListTile(
          leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: CircleAvatar(
                backgroundColor: ThemeColor.unselectedIcons,
              ),
            ),
          ),
          title: Text(_product.description),
          subtitle: Text('Descrição'),
          trailing: Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }
}

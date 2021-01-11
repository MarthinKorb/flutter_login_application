import 'package:flutter/material.dart';

class HorizontalListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color textAccentCardColor = Theme.of(context).accentColor;
    Color textPrimaryCardColor = Theme.of(context).primaryColor;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: textPrimaryCardColor,
        child: Icon(
          Icons.add,
          color: textAccentCardColor,
        ),
        tooltip: 'Criar uma lista',
        onPressed: () {},
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 100.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Ver minhas listas',
                      style: TextStyle(
                        color: textAccentCardColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                color: Colors.deepPurple,
              ),
            ),
            Container(
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Última lista de compras',
                      style: TextStyle(
                        color: textAccentCardColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                color: Colors.deepPurple,
              ),
            ),
            Container(
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Lista de compras',
                      style: TextStyle(
                        color: textAccentCardColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
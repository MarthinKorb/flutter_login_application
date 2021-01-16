import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/alert_dialog_comp.dart';
import 'package:flutter_login_application/utils/theme_color.dart';

class HorizontalListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 6, right: 6),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 100.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Ver minhas listas',
                      style: TextStyle(
                        color: ThemeColor.buttonColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AlertDialogComp(
                          title: 'Teste',
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Teste de Widget'),
                              Text('Teste de Widget')
                            ],
                          ),
                        ));
                  },
                ),
                color: ThemeColor.secundaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Última lista de compras',
                      style: TextStyle(
                        color: ThemeColor.primaryColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                color: ThemeColor.secundaryColor,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              width: 170.0,
              child: Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Lista de compras',
                      style: TextStyle(
                        color: ThemeColor.primaryColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                color: ThemeColor.secundaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

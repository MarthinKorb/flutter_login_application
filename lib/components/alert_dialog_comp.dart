import 'package:flutter/material.dart';
import 'package:flutter_login_application/utils/theme_color.dart';

class AlertDialogComp extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  final Color iconColor;
  final Widget pageToRedirect;

  AlertDialogComp(
      {this.title, this.child, this.icon, this.iconColor, this.pageToRedirect});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(title),
              ),
            ],
          ),
        ),
        content: child,
        actions: [
          FlatButton(
            color: ThemeColor.buttonColor,
            onPressed: () {
              if (pageToRedirect != null) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => pageToRedirect),
                    (route) => false);
              }
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}

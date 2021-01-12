import 'package:flutter/material.dart';

class AlertDialogComp extends StatelessWidget {
  final String title;
  final Widget child;

  AlertDialogComp({this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(title),
        content: child,
        actions: [
          FlatButton(
            color: Colors.deepPurple[300],
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}

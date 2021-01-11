import 'package:flutter/material.dart';

class AlertDialogComp extends StatelessWidget {
  final String title;
  final String contentText;

  AlertDialogComp({this.title, this.contentText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(title),
        content: Text(contentText),
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

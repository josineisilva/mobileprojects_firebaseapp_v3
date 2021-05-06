import 'package:flutter/material.dart';

void showMessage(BuildContext context, String _title, String _body) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
            children: [
              Icon(Icons.cloud,color: Colors.deepOrange,size: 48.0,),
              Expanded(
                child: Text(
                  _title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ]
        ),
        content: Text(_body),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
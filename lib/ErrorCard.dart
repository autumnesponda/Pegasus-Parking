import 'package:flutter/material.dart';

abstract class ErrorCard {
  static Card getCard(String heading, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          ListTile(
            title: Center(child: Text(
              heading,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            )),
            subtitle: Center(child: Text(
                subtitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
          ),
        ]),
      ),
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }
}

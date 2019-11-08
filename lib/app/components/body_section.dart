import 'package:flutter/material.dart';

class BodySection extends StatelessWidget {
  final String title;
  final String content;

  BodySection(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.title),
          Text(content, style: TextStyle(color: Colors.grey[700]))
        ],
      ),
    );
  }
}
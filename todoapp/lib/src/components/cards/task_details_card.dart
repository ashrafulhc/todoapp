import 'package:todoapp/src/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDetailsCard extends StatelessWidget {
  final String title;
  final String body;

  const TaskDetailsCard({
    Key key,
    this.title,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: new BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color(0x3fc2c2c2),
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: ButtonTextStyle.accent),
            SizedBox(height: 17),
            Text(body, style: ButtonTextStyle.small)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/constants/mk_style.dart';
import 'package:flutter_auth_flow/app/components/mk_dates.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: const Border(
          bottom: const MkBorderSide(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Hello",
            style:TextStyle(
              fontSize: 32.0,
              fontWeight: MkStyle.light,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 52.0,
              fontWeight: MkStyle.regular,
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          Text(
            MkDates(DateTime.now(), day: "EEEE", month: "MMMM").format,
            style: TextStyle(
              fontSize: 14.0,
              height: 1.75
            ),
          ),
        ],
      ),
    );
  }
}

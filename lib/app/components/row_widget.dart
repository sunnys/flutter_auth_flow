import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/app/components/helpers.dart';
import 'package:flutter_auth_flow/constants/mk_style.dart';

class RowWidget extends StatelessWidget {
  const RowWidget({
    Key key,
    @required this.height,
    @required this.title1,
    @required this.title2,
    @required this.subTitle1,
    @required this.subTitle2,
    @required this.onPressed1,
    @required this.onPressed2,
  }) : super(key: key);

  final double height;
  final String title1;
  final String title2;
  final String subTitle1;
  final String subTitle2;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        border: const Border(bottom: const MkBorderSide()),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: const Border(
                  right: const MkBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: title1,
                subTitle: subTitle1,
                onPressed: onPressed1,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: title2,
                subTitle: subTitle2,
                onPressed: onPressed2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
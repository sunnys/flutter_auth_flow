import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/constants/mk_style.dart';

enum AccountOptions {
  logout,
  storename,
}

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    Key key,
    @required this.onLogout,
  }) : super(key: key);

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox.fromSize(
            size: const Size.square(48.0),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor.withOpacity(.5),
                  width: 1.5,
                ),
              ),
              child: GestureDetector(
                onTap: onLogout,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    Align(
                      alignment: const Alignment(0.0, 2.25),
                      child: null,
                    ),
                    Align(
                      alignment: Alignment(
                        1.25,
                        1.25,
                      ),
                      child: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

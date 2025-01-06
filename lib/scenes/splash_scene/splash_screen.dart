import 'package:flutter/material.dart';
import 'package:test_application/theme/colors.dart';

class SplashSreen extends StatelessWidget {
  const SplashSreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
              backgroundColor: primaryLightColor,
              body: Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Image.asset('assets/images/nba_logo.png'),
                ),
              ),
            ));
  }
}

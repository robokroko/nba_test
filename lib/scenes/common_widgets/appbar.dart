import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_application/theme/colors.dart';

class NBAAppbar extends StatelessWidget {
  final void Function()? onPressed;
  const NBAAppbar({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryBlueColor,
      title: Text('teams.title'.tr()),
    );
  }
}

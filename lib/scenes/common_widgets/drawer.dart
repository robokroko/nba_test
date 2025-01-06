import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_application/modules/security_module/model.dart';
import 'package:test_application/modules/security_module/security_module.dart';
import 'package:test_application/scenes/login_scene/login_screen.dart';
import 'package:test_application/theme/colors.dart';

class NBATestAppDrawer extends StatelessWidget {
  final User? user;

  const NBATestAppDrawer({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryLightColor,
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: primaryRedColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: primaryLightColor,
                radius: 30,
                child: Icon(Icons.person, size: 50, color: primaryBlueColor),
              ),
              Text(
                user?.username ?? '',
                style: const TextStyle(color: primaryLightColor),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: primaryBlueColor),
          title: Text(
            'logout'.tr(),
            style: const TextStyle(color: primaryBlueColor),
          ),
          onTap: () {
            context.read<SecurityModule>().logout();
            context.go(LoginScreen.routeName);
          },
        )
      ]),
    );
  }
}

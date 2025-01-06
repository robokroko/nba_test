import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_application/modules/security_module/security_module.dart';
import 'package:test_application/modules/security_module/security_state.dart';
import 'package:test_application/scenes/common_widgets/buttons.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_list_screen.dart';
import 'package:test_application/store_and_utilities/model.dart';
import 'package:test_application/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  bool obscurePassword = true;

  void onLoginPressed() {
    context.read<SecurityModule>().credentialLogin().then((securityError) {
      if (mounted) {
        if (securityError != null) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(securityError.errorKey.tr(), style: const TextStyle(color: primaryLightColor)),
            backgroundColor: primaryRedColor,
          ));
        }

        context.go(NBATeamListScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecurityModule, SecurityState>(
      builder: (context, state) {
        final obscurePassword = state.obscurePassword;
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 70),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 400,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Image.asset('assets/images/nba_logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        cursorColor: primaryRedColor,
                        cursorHeight: 20,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: primaryBlueColor, fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: lineColor), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: const Icon(Icons.person_2_outlined),
                            suffixIconColor: textColor,
                            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            labelText: 'login.form.label.user'.tr(),
                            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlueColor)),
                        controller: _keyController,
                        onEditingComplete: () {
                          context.read<SecurityModule>().onKeyChanged(_keyController.text);
                        },
                        onChanged: (String value) {
                          context.read<SecurityModule>().onKeyChanged(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: TextFormField(
                        obscureText: obscurePassword,
                        obscuringCharacter: '*',
                        cursorColor: primaryRedColor,
                        cursorHeight: 20,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: primaryBlueColor, fontSize: 14),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: lineColor), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined),
                              onPressed: () {
                                context.read<SecurityModule>().obscurePasswordChanged(!obscurePassword);
                              }),
                          suffixIconColor: textColor,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: lineColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              )),
                          labelText: 'login.form.label.password'.tr(),
                          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlueColor),
                        ),
                        controller: _secretController,
                        onEditingComplete: () {
                          context.read<SecurityModule>().onSecretChanged(_secretController.text);
                        },
                        onChanged: (String value) {
                          context.read<SecurityModule>().onSecretChanged(value);
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 60),
                      child: state.loginResult.progress == AsyncProgress.idle
                          ? ActionButton(
                              onPressed: onLoginPressed,
                              text: 'login.login'.tr(),
                            )
                          : const LoadingCircleButton(color: primaryBlueColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _secretController.dispose();
    _keyController.dispose();
    super.dispose();
  }
}

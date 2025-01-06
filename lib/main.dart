import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_application/app.dart';
import 'package:test_application/gateways/http_service.dart';
import 'package:test_application/gateways/nba_teams_provider/nba_teams_provider_api.dart';
import 'package:test_application/gateways/security/security_api.dart';
import 'package:test_application/gateways/test_app_http_service.dart';
import 'package:test_application/gateways/test_app_security_service%20.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_module.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_state.dart';
import 'package:test_application/modules/security_module/security_module.dart';
import 'package:test_application/modules/security_module/security_state.dart';
import 'package:test_application/modules/security_module/security_repository.dart';
import 'package:test_application/store_and_utilities/environment.dart';
import 'package:test_application/store_and_utilities/secure_storage_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  const secureStorage = FlutterSecureStorage();
  final SecurityRepository securityRepository = SecureStorageSecurityRepository(secureStorage);

  final HttpService httpClient = HttpClient(Environment.baseUrl);
  final TestAppHttpService httpNBATeamsProviderService = TestAppHttpService(httpClient);
  final TestAppSecurityService securityService = TestAppSecurityService();
  final SecurityApi securityApi = HttpSecurityApi(securityRepository, securityService);
  final NBATeamsApi nbaTeamsApi = HttpTeamApi(httpNBATeamsProviderService);
  final SecureStorage secureStorageStore = SecureStorage(secureStorage);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: MultiBlocProvider(providers: [
      BlocProvider(create: (context) => SecurityModule(SecurityState.initial(), securityApi, securityRepository)),
      BlocProvider<NBATeamsProviderModule>(
          create: (context) => NBATeamsProviderModule(NBATeamsProviderState.initial(), nbaTeamsApi, secureStorageStore, securityRepository)),
    ], child: const TestApp()),
  ));
}

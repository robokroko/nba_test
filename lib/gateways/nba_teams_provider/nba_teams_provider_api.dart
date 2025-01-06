import 'package:test_application/gateways/http_service.dart';
import 'package:test_application/gateways/test_app_http_service.dart';
import 'package:test_application/modules/nba_teams_provider_module/model.dart';
import 'package:test_application/store_and_utilities/environment.dart';

abstract class NBATeamsApi {
  Future<List<Team>> getTeams();
}

class HttpTeamApi extends NBATeamsApi {
  final TestAppHttpService _http;

  HttpTeamApi(this._http);

  @override
  Future<List<Team>> getTeams() {
    return _http
        .getArray(
          RequestConfig(path: '/teams?key=${Environment.apiKey}', headers: {'Content-Type': 'application/json'}),
        )
        .then((teams) => (teams).map((team) => Team.fromJson(team)).toList());
  }
}

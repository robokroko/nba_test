import 'package:test_application/gateways/nba_teams_provider/nba_teams_provider_api.dart';
import 'package:test_application/store_and_utilities/data_channel.dart';
import 'package:test_application/store_and_utilities/store.dart';

import 'model.dart';

class NBATeamsRepository {
  final Store<List<Team>> _teamStore;
  final NBATeamsApi _teamsApi;

  NBATeamsRepository(this._teamStore, this._teamsApi);

  DataChannel<List<Team>> getTeams() {
    return DataChannel<List<Team>>(_teamStore, 'teams', () => _teamsApi.getTeams());
  }
}

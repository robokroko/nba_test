import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_application/gateways/nba_teams_provider/nba_teams_provider_api.dart';
import 'package:test_application/modules/nba_teams_provider_module/model.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_state.dart';
import 'package:test_application/modules/security_module/model.dart';
import 'package:test_application/modules/security_module/security_repository.dart';
import 'package:test_application/store_and_utilities/secure_storage_store.dart';

class NBATeamsProviderModule extends Bloc<NBATeamsProviderEvent, NBATeamsProviderState> {
  final NBATeamsApi _nbaTeamsApi;
  final SecureStorage _secureStorage;
  final SecurityRepository _securityRepository;

  NBATeamsProviderModule(
    super.initialState,
    this._nbaTeamsApi,
    this._secureStorage,
    this._securityRepository,
  ) {
    on<NBATeamsProviderEvent>((event, emit) {
      emit(event.reducer(state));
    });
  }

  Future<NBATemasProviderError?> fetchNBATeams() {
    add(OnFetchTeamsStarted());
    return resolveUser().then<NBATemasProviderError?>((user) {
      if (user == null) {
        add(OnFetchTeamsFailed(NBATemasProviderError.unauthorized));
        return Future.value();
      }

      return _nbaTeamsApi.getTeams().then<NBATemasProviderError?>((teams) {
        if (teams.isEmpty) {
          add(OnFetchTeamsSucceeded(null));
        }
        return _secureStorage.getIntList(user.username).then<NBATemasProviderError?>((favoriteTeamIds) {
          if (favoriteTeamIds.isEmpty) {
            add(OnFetchTeamsSucceeded(teams));
            return Future.value(null);
          }

          final checkedTeams = teams.map((team) {
            if (favoriteTeamIds.contains(team.teamID)) {
              return team.copyWith(favorite: true);
            }
            return team;
          }).toList();

          add(OnFetchTeamsSucceeded(checkedTeams));
          return Future.value(null);
        }).catchError((error) {
          add(OnFetchTeamsFailed(NBATemasProviderError.failedToLoadTeams));
          return NBATemasProviderError.failedToLoadTeams;
        });
      });
    }).catchError((error) {
      add(OnFetchTeamsFailed(NBATemasProviderError.failedToLoadTeams));
      return NBATemasProviderError.failedToLoadTeams;
    });
  }

  Future<void> changeFavoritePropertyOfTeam(int id) {
    return resolveUser().then((user) {
      if (user != null) {
        return _secureStorage.getIntList(user.username).then((favoriteTeamIds) {
          if (favoriteTeamIds.contains(id)) {
            _secureStorage.removeElementFromList(user.username, id);
          } else {
            _secureStorage.addElementToList(user.username, id);
          }

          add(OnChangeTeamElementFavorite(id));
        });
      }
    });
  }

  Future<void> setSelectedTeam(Team? team) {
    add(OnChangeSelectedTeam(team));
    return Future.value();
  }

  void changeSelectVisibleOnlyFavoriteTeams(bool visible) {
    add(OnSelectOnlyVisibleSwitch(visible));
  }

  Future<User?> resolveUser() {
    return _securityRepository.getUser().then((user) {
      if (user == null) {
        throw Exception('missing-user');
      }

      return user;
    });
  }
}

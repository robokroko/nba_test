import 'package:test_application/modules/nba_teams_provider_module/model.dart';
import 'package:test_application/store_and_utilities/model.dart';

class NBATeamsProviderState {
  final AsyncResult<List<Team>, NBATemasProviderError> teamsResult;
  final Team? selectedTeam;
  final bool onlyFavoriteTeamsVisible;

  NBATeamsProviderState(this.teamsResult, this.selectedTeam, this.onlyFavoriteTeamsVisible);

  factory NBATeamsProviderState.initial() => NBATeamsProviderState(AsyncResult<List<Team>, NBATemasProviderError>.initial(null), null, false);

  NBATeamsProviderState copyWith({
    AsyncResult<List<Team>, NBATemasProviderError>? teamsResult,
    Team? selectedTeam,
    bool? onlyFavoriteTeamsVisible,
  }) =>
      NBATeamsProviderState(
        teamsResult ?? this.teamsResult,
        selectedTeam ?? this.selectedTeam,
        onlyFavoriteTeamsVisible ?? this.onlyFavoriteTeamsVisible,
      );

  NBATeamsProviderState copyWithTeamsResult({AsyncProgress? progress, Set<NBATemasProviderError>? errors, List<Team>? result}) => copyWith(
      teamsResult: teamsResult.copyWith(
          progress: progress ?? teamsResult.progress, errors: errors ?? teamsResult.errors, result: result ?? teamsResult.result));
}

abstract class NBATeamsProviderEvent {
  NBATeamsProviderState reducer(NBATeamsProviderState state);
}

class OnFetchTeamsStarted extends NBATeamsProviderEvent {
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) {
    return state.copyWithTeamsResult(progress: AsyncProgress.busy, errors: <NBATemasProviderError>{});
  }
}

class OnFetchTeamsFailed extends NBATeamsProviderEvent {
  final NBATemasProviderError error;
  OnFetchTeamsFailed(this.error);
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) {
    final errors = Set<NBATemasProviderError>.from(state.teamsResult.errors);
    errors.add(error);
    return state.copyWithTeamsResult(progress: AsyncProgress.idle, errors: errors);
  }
}

class OnFetchTeamsSucceeded extends NBATeamsProviderEvent {
  final List<Team>? teams;

  OnFetchTeamsSucceeded(this.teams);
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) {
    return state.copyWithTeamsResult(progress: AsyncProgress.idle, result: teams, errors: <NBATemasProviderError>{});
  }
}

class OnChangeTeamElementFavorite extends NBATeamsProviderEvent {
  final int id;

  OnChangeTeamElementFavorite(this.id);
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) {
    final teams = state.teamsResult.result;

    final checkedTeams = teams?.map((team) {
      if (team.teamID == id) {
        return team.copyWith(favorite: !team.favorite);
      }
      return team;
    }).toList();

    return state.copyWithTeamsResult(progress: AsyncProgress.idle, result: checkedTeams, errors: <NBATemasProviderError>{});
  }
}

class OnChangeSelectedTeam extends NBATeamsProviderEvent {
  final Team? team;

  OnChangeSelectedTeam(this.team);
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) => state.copyWith(selectedTeam: team);
}

class OnSelectOnlyVisibleSwitch extends NBATeamsProviderEvent {
  final bool? visible;

  OnSelectOnlyVisibleSwitch(this.visible);
  @override
  NBATeamsProviderState reducer(NBATeamsProviderState state) => state.copyWith(onlyFavoriteTeamsVisible: visible);
}

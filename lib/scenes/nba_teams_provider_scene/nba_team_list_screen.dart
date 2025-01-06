import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_application/modules/nba_teams_provider_module/model.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_module.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_state.dart';
import 'package:test_application/modules/security_module/security_module.dart';
import 'package:test_application/scenes/common_widgets/appbar.dart';
import 'package:test_application/scenes/common_widgets/drawer.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_card.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_details_screen.dart';
import 'package:test_application/store_and_utilities/model.dart';
import 'package:test_application/theme/colors.dart';
import 'package:test_application/theme/styles.dart';

class NBATeamListScreen extends StatefulWidget {
  static const routeName = '/nba-teams-provider';
  const NBATeamListScreen({
    super.key,
  });

  @override
  State<NBATeamListScreen> createState() => _NBATeamListScreenState();
}

class _NBATeamListScreenState extends State<NBATeamListScreen> {
  @override
  void initState() {
    context.read<NBATeamsProviderModule>().fetchNBATeams().then((error) {
      if (mounted) {
        if (error != null) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.errorKey.tr(), style: const TextStyle(color: primaryLightColor)),
            backgroundColor: primaryRedColor,
          ));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NBATeamsProviderModule, NBATeamsProviderState>(
      builder: (context, state) {
        final AsyncProgress progress = state.teamsResult.progress;
        final List<Team>? teams = state.teamsResult.result;
        final List<Team> favoriteTeams = teams?.where((team) => team.favorite).toList() ?? [];
        final bool onlyFavoriteTeamsVisible = state.onlyFavoriteTeamsVisible;

        return Scaffold(
          drawer: NBATestAppDrawer(user: context.read<SecurityModule>().state.user),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: NBAAppbar(onPressed: () => Scaffold.of(context).openDrawer()),
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<NBATeamsProviderModule>().fetchNBATeams().then((error) {
              if (mounted) {
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.errorKey.tr(), style: const TextStyle(color: primaryLightColor)),
                    backgroundColor: primaryRedColor,
                  ));
                }
              }
            }),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('teams.change_favorite_visibility'.tr(), style: titleMiniTextStyle),
                        Switch(
                          inactiveThumbColor: primaryLightColor,
                          activeColor: primaryLightColor,
                          activeTrackColor: primaryBlueColor,
                          value: onlyFavoriteTeamsVisible,
                          onChanged: (bool visible) {
                            context.read<NBATeamsProviderModule>().changeSelectVisibleOnlyFavoriteTeams(visible);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text('teams.title'.tr(), style: titleMiniTextStyle),
                  ),
                  _buildContent(onlyFavoriteTeamsVisible ? favoriteTeams : teams, progress),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(List<Team>? teams, AsyncProgress progress) {
    if (progress == AsyncProgress.busy) {
      return _loadingState();
    }
    if (teams == null || teams.isEmpty) {
      return _emptyState();
    }
    return _getListView(teams);
  }

  Widget _getListView(List<Team> teams) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return NBATeamCard(
          favorite: team.favorite,
          key: ValueKey(team.teamID),
          name: team.name,
          imageKey: team.wikipediaLogoUrl,
          openDetails: () => context.read<NBATeamsProviderModule>().setSelectedTeam(team).then((_) {
            context.push(NBATeamDetailScreen.routeName);
          }),
          setAsFavorite: () => context.read<NBATeamsProviderModule>().changeFavoritePropertyOfTeam(team.teamID),
        );
      },
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Text(
          'teams.no_teams'.tr(),
          style: titleMiniTextStyle,
        ),
      ),
    );
  }

  Widget _loadingState() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'loading'.tr(),
                style: titleMiniTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

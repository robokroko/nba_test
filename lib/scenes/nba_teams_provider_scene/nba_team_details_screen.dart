import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_application/modules/nba_teams_provider_module/model.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_module.dart';
import 'package:test_application/modules/nba_teams_provider_module/nba_teams_provider_state.dart';
import 'package:test_application/scenes/common_widgets/buttons.dart';
import 'package:test_application/scenes/common_widgets/network_imageviewer.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_detail_row.dart';
import 'package:test_application/theme/colors.dart';

class NBATeamDetailScreen extends StatefulWidget {
  static const routeName = '/team-detail';

  const NBATeamDetailScreen({
    super.key,
  });

  @override
  State<NBATeamDetailScreen> createState() => _NBATeamDetailScreenState();
}

class _NBATeamDetailScreenState extends State<NBATeamDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        context.read<NBATeamsProviderModule>().setSelectedTeam(null);
      },
      child: Scaffold(
        backgroundColor: primaryBlueColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 20, right: 20),
          child: BlocBuilder<NBATeamsProviderModule, NBATeamsProviderState>(builder: (context, state) {
            final Team? team = state.selectedTeam;
            if (team == null) {
              return Center(
                child: Text('selected_team.no_team_selected_yet'.tr()),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: NetworkImageViewer(
                            imageKey: team.wikipediaLogoUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      if (team.favorite)
                        const Icon(
                          size: 40,
                          Icons.star,
                          color: starYellow,
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NBATeamDetailRow(title: 'team_details.name'.tr(), text: team.name),
                    NBATeamDetailRow(title: 'team_details.city'.tr(), text: team.city),
                    NBATeamDetailRow(title: 'team_details.head_coach'.tr(), text: team.headCoach),
                    NBATeamDetailRow(title: 'team_details.division'.tr(), text: team.division),
                    NBATeamDetailRow(title: 'team_details.conference'.tr(), text: team.conference),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 40, right: 40),
                  child: ActionButton(
                    color: primaryRedColor,
                    text: 'teams.back'.tr(),
                    onPressed: () {
                      context.read<NBATeamsProviderModule>().setSelectedTeam(null);
                      context.pop();
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

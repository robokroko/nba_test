import 'package:flutter/material.dart';
import 'package:test_application/theme/colors.dart';
import 'package:test_application/theme/styles.dart';

class NBATeamCard extends StatefulWidget {
  final String name;
  final String imageKey;
  final void Function() openDetails;
  final void Function() setAsFavorite;
  final bool favorite;
  const NBATeamCard({
    super.key,
    required this.openDetails,
    required this.setAsFavorite,
    required this.imageKey,
    required this.name,
    required this.favorite,
  });

  @override
  State<NBATeamCard> createState() => _NBATeamCardState();
}

class _NBATeamCardState extends State<NBATeamCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: GestureDetector(
        onTap: widget.openDetails,
        child: Container(
          decoration: primaryBoxDecoration,
          constraints: const BoxConstraints(maxHeight: 120),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: panelDescriptionTextStyle,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.star),
                                color: widget.favorite ? starYellow : primaryTextColor,
                                onPressed: widget.setAsFavorite),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

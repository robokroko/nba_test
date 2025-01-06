import 'package:flutter/material.dart';

class NBATeamDetailRow extends StatefulWidget {
  final String title;
  final String text;

  const NBATeamDetailRow({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  State<NBATeamDetailRow> createState() => _NBATeamDetailRowState();
}

class _NBATeamDetailRowState extends State<NBATeamDetailRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 16)),
          Text(widget.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

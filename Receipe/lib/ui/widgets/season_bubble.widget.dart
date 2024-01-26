import 'package:flutter/material.dart';
import 'package:receipe/data/database.dart';
import 'package:receipe/data/service/season_service.dart';

class SeasonBubble extends StatefulWidget {
  SeasonBubble({
    Key? key,
    required this.season,
    this.scale = 1, required bool isSelected,
  }) : super(key: key);

  final Season season;
  final double scale;

  @override
  State<SeasonBubble> createState() => _SeasonBubbleState();
}

class _SeasonBubbleState extends State<SeasonBubble> {
  late SeasonService seasonService = SeasonService();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      setState(() {
        isSelected = !isSelected;
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? seasonService.getColor(widget.season) : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: Text(
        widget.season.title,
        style: const TextStyle(
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textScaleFactor: widget.scale,
      ),
    ),
  );
}

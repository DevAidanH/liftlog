import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class myHeatmap extends StatelessWidget {
  final Map<DateTime, int>? datasets;

  const myHeatmap({
    super.key,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
      child: HeatMapCalendar(
        datasets: datasets,
        colorMode: ColorMode.color,
        showColorTip: false,
        margin: EdgeInsets.all(2),
        size: 45,
        textColor: Colors.black,
        defaultColor: Theme.of(context).colorScheme.surface,
        weekTextColor: Colors.black,
        colorsets: {
          1: Color(0xFF5DA349).withAlpha(43),
          2: Color(0xFF5DA349).withAlpha(85),
          3: Color(0xFF5DA349).withAlpha(128),
          4: Color(0xFF5DA349).withAlpha(170),
          5: Color(0xFF5DA349).withAlpha(213),
          6: Color(0xFF5DA349).withAlpha(255),
        }
      ),
    );
  }
}
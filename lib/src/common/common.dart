import 'package:flutter/material.dart';
import 'package:growth_standards/growth_standards.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPlot extends StatelessWidget {
  const ChartPlot({
    super.key,
    required this.maleMaxX,
    required this.maleMinX,
    required this.maleZScore,
  });

  final int maleMaxX;
  final int maleMinX;
  final Map<int, Map<ZScoreValue, num>> maleZScore;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: const Legend(
        isVisible: true,
      ),
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        maximum: maleMaxX.toDouble(),
        minimum: maleMinX.toDouble(),
        labelFormat: '{value} days',
        axisLine: const AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorTickLines: const MajorTickLines(size: 0, width: 0.1),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 5,
        maximum: 25,
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value} cm',
        majorTickLines: MajorTickLines(size: 0, width: 0.1),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: zScoreGen(maleZScore),
    );
  }
}

List<SplineSeries<Map<ZScoreValue, num>, num>> zScoreGen(
  Map<int, Map<ZScoreValue, num>> zs,
) {
  final reverse = zs.swapKV;
  return zs.entries.first.value.keys.map((zScore) {
    return SplineSeries<Map<ZScoreValue, num>, num>(
      dataSource: zs.values.toList(),
      xValueMapper: (dx, _) => reverse[dx]!,
      yValueMapper: (dy, _) => dy[zScore],
      markerSettings: const MarkerSettings(isVisible: true),
      name: '${zScore.value} SD',
    );
  }).toList();
}

List<SplineSeries<Map<PercentileValue, num>, num>> percentileGen(
  Map<int, Map<PercentileValue, num>> perc,
) {
  final reverse = perc.swapKV;
  return perc.entries.first.value.keys.map((percentile) {
    return SplineSeries<Map<PercentileValue, num>, num>(
      dataSource: perc.values.toList(),
      xValueMapper: (dx, _) => reverse[dx]!,
      yValueMapper: (dy, _) => dy[percentile],
      markerSettings: const MarkerSettings(isVisible: true),
      name: '${percentile.value} percentile',
    );
  }).toList();
}

final zScoreColorMap = {
  ZScoreValue.neg3: const Color.fromARGB(255, 216, 20, 6),
  ZScoreValue.neg2: Colors.orange,
  ZScoreValue.neg1: Colors.yellow,
  ZScoreValue.zero: const Color.fromARGB(255, 3, 138, 7),
  ZScoreValue.pos1: Colors.yellow,
  ZScoreValue.pos2: Colors.orange,
  ZScoreValue.pos3: const Color.fromARGB(255, 216, 20, 6),
};

extension MapExt<T> on Map<num, Map<T, num>> {
  Map<Map<T, num>, num> get swapKV => map((key, value) => MapEntry(value, key));
}

const usedZScore = [
  ZScoreValue.neg3,
  ZScoreValue.neg2,
  ZScoreValue.neg1,
  ZScoreValue.zero,
  ZScoreValue.pos1,
  ZScoreValue.pos2,
  ZScoreValue.pos3,
];

const usedPercentile = [
  PercentileValue.$3,
  PercentileValue.$10,
  PercentileValue.$25,
  PercentileValue.$50,
  PercentileValue.$75,
  PercentileValue.$90,
  PercentileValue.$97,
];

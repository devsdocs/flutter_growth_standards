import 'package:flutter/material.dart';
import 'package:growth_standards/growth_standards.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WHOArmCircumferenceChart extends StatelessWidget {
  WHOArmCircumferenceChart({
    super.key,
  });

  final armCircumference = WHOGrowthStandardsArmCircumferenceForAgeData();

  @override
  Widget build(BuildContext context) {
    final male = armCircumference.data[Sex.male]?.ageData;
    final female = armCircumference.data[Sex.female]?.ageData;

    final maleData = male?.entries;

    final maleZScore = Map.fromEntries(
      maleData!.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.standardDeviationCutOff.entries.toList()
              ..removeWhere(
                (element) => ![
                  ZScoreValue.neg3,
                  ZScoreValue.neg2,
                  ZScoreValue.neg1,
                  ZScoreValue.zero,
                  ZScoreValue.pos1,
                  ZScoreValue.pos2,
                  ZScoreValue.pos3,
                ].contains(element.key),
              ),
          ),
        ),
      ),
    );

    final malePercentile = Map.fromEntries(
      maleData.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.percentileCutOff.entries.toList()
              ..removeWhere(
                (element) => ![
                  PercentileValue.$3,
                  PercentileValue.$10,
                  PercentileValue.$25,
                  PercentileValue.$50,
                  PercentileValue.$75,
                  PercentileValue.$90,
                  PercentileValue.$97,
                ].contains(element.key),
              ),
          ),
        ),
      ),
    );

    final femaleData = female?.entries;

    final femaleZScore = Map.fromEntries(
      femaleData!.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.standardDeviationCutOff.entries.toList()
              ..removeWhere(
                (element) => ![
                  // ZScoreValue.neg3,
                  // ZScoreValue.neg2,
                  // ZScoreValue.neg1,
                  ZScoreValue.zero,
                  // ZScoreValue.pos1,
                  // ZScoreValue.pos2,
                  // ZScoreValue.pos3,
                ].contains(element.key),
              ),
          ),
        ),
      ),
    );

    final femalePercentile = Map.fromEntries(
      femaleData.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.percentileCutOff.entries.toList()
              ..removeWhere(
                (element) => ![
                  PercentileValue.$3,
                  PercentileValue.$10,
                  PercentileValue.$25,
                  PercentileValue.$50,
                  PercentileValue.$75,
                  PercentileValue.$90,
                  PercentileValue.$97,
                ].contains(element.key),
              ),
          ),
        ),
      ),
    );

    final maleMinX =
        maleZScore.entries.reduce((p, a) => p.key < a.key ? p : a).key;

    final maleMaxX =
        maleZScore.entries.reduce((p, a) => p.key > a.key ? p : a).key;

    final femaleMinX =
        femaleZScore.entries.reduce((p, a) => p.key < a.key ? p : a).key;

    final femaleMaxX =
        femaleZScore.entries.reduce((p, a) => p.key > a.key ? p : a).key;

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
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 5,
        maximum: 30,
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value} cm',
        majorTickLines: MajorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: seriesGen(maleZScore),
    );
  }

  List<SplineSeries<Map<ZScoreValue, num>, num>> seriesGen(
    Map<int, Map<ZScoreValue, num>> maleZScore,
  ) {
    final reverse = maleZScore.map((key, value) => MapEntry(value, key));
    return maleZScore.entries.first.value.keys.map((e) {
      final mat = ZScoreValue.values.singleWhere((element) => element == e);
      return SplineSeries<Map<ZScoreValue, num>, num>(
        dataSource: maleZScore.values.toList(),
        xValueMapper: (dx, _) => reverse[dx],
        yValueMapper: (dy, _) => dy[mat],
        markerSettings: const MarkerSettings(isVisible: true),
        name: '${mat.value} SD',
      );
    }).toList();
  }
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
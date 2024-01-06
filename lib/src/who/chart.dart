import 'package:flutter/material.dart';
import 'package:flutter_growth_standards/src/common/common.dart';
import 'package:growth_standards/growth_standards.dart';

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
    final femaleData = female?.entries;

    final maleZScore = Map.fromEntries(
      maleData!.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.standardDeviationCutOff.entries.toList()
              ..removeWhere(
                (element) => !usedZScore.contains(element.key),
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
                (element) => !usedPercentile.contains(element.key),
              ),
          ),
        ),
      ),
    );

    final femaleZScore = Map.fromEntries(
      femaleData!.map(
        (e) => MapEntry(
          e.key,
          Map.fromEntries(
            e.value.standardDeviationCutOff.entries.toList()
              ..removeWhere(
                (element) => !usedZScore.contains(element.key),
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
                (element) => !usedPercentile.contains(element.key),
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

    return ChartPlot(
      maleMaxX: maleMaxX,
      maleMinX: maleMinX,
      maleZScore: maleZScore,
    );
  }
}

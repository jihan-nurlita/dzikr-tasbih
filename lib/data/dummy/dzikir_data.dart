import 'package:dzikr_tasbih/models/dzikir_model.dart';

final List<DzikirModel> defaultDzikirList = [
  DzikirModel(
    title: "Subhanallah",
    target: 33,
  ),
  DzikirModel(
    title: "Alhamdulillah",
    target: 33,
  ),
  DzikirModel(
    title: "Allahu Akbar",
    target: 33,
  ),
  DzikirModel(
    title: "Astaghfirullah",
    target: 100,
  ),
  DzikirModel(
    title: "La ilaha illallah",
    target: 100,
  ),
];

List<DzikirModel> dzikirList = List.from(defaultDzikirList);

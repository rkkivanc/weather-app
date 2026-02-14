class DailyForecastModel {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String mainCondition;

  DailyForecastModel({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.mainCondition,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemperature: (json['main']['temp_max'] as num).toDouble(),
      minTemperature: (json['main']['temp_min'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }

}
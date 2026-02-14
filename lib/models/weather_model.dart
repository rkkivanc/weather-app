class WeatherModel {
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String weatherMain;
  final String weatherDescription;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherMain,
    required this.weatherDescription,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      weatherMain: json['weather'][0]['main'],
      weatherDescription: json['weather'][0]['description'],
    );
  }

}
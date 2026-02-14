import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:weather_application/constants.dart';
import 'package:weather_application/models/weather_model.dart';
import 'package:weather_application/services/weather_service.dart';

class WeatherHomeBody extends StatelessWidget {
   WeatherHomeBody({super.key, required this.cityName});

  final String cityName;

  static const double dailyForecastSpacing = 25.0;
  static const double dailyForecastContainerHeight = 100.0;
  static const double dailyForecastContainerPadding = 16.0;
  static const double dailyForecastContainerBorderRadius = 48.0;

  // ignore: deprecated_member_use
  final Color dailyForecastContainerColor = Colors.black.withOpacity(0.2);

  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _weatherService.getCurrentWeather(cityName),
        _weatherService.fetch5DayForecast(cityName),
      ]),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if(snapshot.hasError) {
          return Center(child: Text("Error ${snapshot.error}"));
        } else if(!snapshot.hasData) {
          return const Center(child: Text("No data found"));
        }

        final weatherData = snapshot.data![0] as WeatherModel;
        final dailyForecastData = snapshot.data![1] as List<dynamic>;

        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                Expanded(
                  child: Lottie.asset(
                    getLottieAsset(weatherData.weatherMain),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WindColumn(windSpeed: weatherData.windSpeed),
                    TemperatureColumn(
                      temperature: weatherData.temperature,
                      weatherDescription: weatherData.weatherDescription.toTitleCase(),
                    ),
                    HumidityColumn(humidity: weatherData.humidity),
                  ],
                ),
                SizedBox(height: AppSizes.spacingVerticalSmall),
                DailyForecastTitle(),
                SizedBox(height: AppSizes.spacingVerticalSmall),
                Expanded(
                  child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(height: dailyForecastSpacing),
                  itemBuilder:(context, index) {
                    
                    final dayData = dailyForecastData[index];

                    return Container(
                      height: dailyForecastContainerHeight,
                      padding: EdgeInsets.all(dailyForecastContainerPadding),
                      decoration: BoxDecoration(
                      color: dailyForecastContainerColor,
                      borderRadius: BorderRadius.circular(dailyForecastContainerBorderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('EEEE').format(dayData.date)),
                        Lottie.asset(
                          getLottieAsset(dayData.mainCondition),
                          width: 60,
                        ),
                        Text("${dayData.maxTemperature.round()}° / ${dayData.minTemperature.round()}°",
                          style: const TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                  },
                  ),
                ),
              ],
            ),
          ),
        );      
      }
    );
  }
}

class DailyForecastTitle extends StatelessWidget {
  const DailyForecastTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: AppSizes.iconSize,
        ),
        SizedBox(width: AppSizes.spacingHorizontalSmall),
        const Text(AppTexts.dailyForecast, style: TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class HumidityColumn extends StatelessWidget {
  const HumidityColumn({
    super.key, required this.humidity,
  });

  final int humidity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.spacingVerticalLarge),
        PhosphorIcon(
          PhosphorIcons.dropSimple(),
          size: AppSizes.iconSize,
        ),
        const Text(AppTexts.humidity, style: TextStyle(fontSize: AppSizes.fontSmall)),
        Text("$humidity%", style: TextStyle(fontSize: AppSizes.fontSmall)),
      ],
    );
  }
}

class TemperatureColumn extends StatelessWidget {
  const TemperatureColumn({
    super.key, required this.temperature, required this.weatherDescription,
  });

  final double temperature;
  final String weatherDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("${temperature.round()}°", style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
            Column(
              children: [
                Text("", style: const TextStyle(fontSize: AppSizes.fontMedium)),
                Text("°C", style: const TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Text(weatherDescription, style: const TextStyle(fontSize: AppSizes.fontSmall))
      ],
    );
  }
}

class WindColumn extends StatelessWidget {
  const WindColumn({
    super.key, required this.windSpeed,
  });

  final double windSpeed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.spacingVerticalLarge),
        PhosphorIcon(
          PhosphorIcons.wind(),
          size: AppSizes.iconSize,
        ),
        const Text(AppTexts.wind, style: TextStyle(fontSize: AppSizes.fontSmall)),
        Text("${windSpeed.round()} km/h", style: TextStyle(fontSize: AppSizes.fontSmall)), 
      ],
    );
  }
}

String getLottieAsset(String weatherMain) {
  switch(weatherMain) {
    case "Clear": return "assets/lottie/sunny.json";
    case "Clouds": return "assets/lottie/cloudy.json";
    case "Rain": return "assets/lottie/rain.json";
    case "Drizzle": return "assets/lottie/rain.json";
    case "Thunderstorm": return "assets/lottie/thunderstorm.json";
    case "Snow": return "assets/lottie/snow.json";
    case "Mist":
    case "Smoke":
    case "Haze":
    case "Dust":
    case "Fog":
    case "Sand":
    case "Ash":
    case "Squall":
    case "Tornado": return "assets/lottie/atmosphere.json";
    default: return "assets/lottie/sunny.json";

  }
}

extension StringExtension on String {
  String toTitleCase() {
    if(isEmpty) return this;
    return split(' ').map((word) {
      if(word.isEmpty) return word;
      return "${word[0].toUpperCase() + word.substring(1).toLowerCase()}";
    }).join(' ');
  }
}

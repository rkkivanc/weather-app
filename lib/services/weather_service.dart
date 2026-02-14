import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_application/models/forecast_model.dart';
import 'package:weather_application/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();

  final String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<WeatherModel> getCurrentWeather(String cityName) async {

    final String url = '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric';

    try {
      final response = await _dio.get(url);
      
      if(response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load weather data");
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<List<DailyForecastModel>> fetch5DayForecast(String cityName) async {

    final String url = 'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$_apiKey&units=metric';
    
    try {
      final response = await _dio.get(url);

      if(response.statusCode == 200) {
        final List<dynamic> rawList = response.data['list'];
        return rawList
        .map((json) => DailyForecastModel.fromJson(json))
        .where((element) => element.date.hour == 12)
        .toList();
      } else {
        throw Exception("Failed to load 7-day forecast data");
      }
    } catch (e) {
      rethrow;
    }

  }

}


Future<String> getCurrentCity() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      throw Exception("Location permissions are denied");
    }
  }

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

  String? city = placemark[0].locality;

  return city ?? '';
}
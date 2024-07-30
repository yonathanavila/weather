import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

var apiKey = dotenv.env['OPEN_WEATHER_API_KEY'];
const baseAPI = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getLocationWeatherByName(String locationName) async {
    NetworkHelper networkHelper =
        NetworkHelper('$baseAPI?q=$locationName&appid=$apiKey&units=metric');
    var weatherResponse = await networkHelper.getData();
    return weatherResponse;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$baseAPI?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherResponse = await networkHelper.getData();

    return weatherResponse;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

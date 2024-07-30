import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

var apiKey = dotenv.env['OPEN_WEATHER_API_KEY'];
const baseAPI = 'https://api.openweathermap.org/data/2.5';

class WeatherModel {
  Future<dynamic> getLocationWeatherByName(String locationName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$baseAPI/weather?q=$locationName&appid=$apiKey&units=metric');
    var weatherResponse = await networkHelper.getData();
    var location = weatherResponse["coord"];
    var airPollution = await getAirPollution(location["lat"], location["lon"]);
    print('airPollution $airPollution');

    return (weatherResponse, airPollution);
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$baseAPI/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherResponse = await networkHelper.getData();

    var airPollution =
        await getAirPollution(location.latitude, location.longitude);

    return (weatherResponse, airPollution);
  }

  Future<dynamic> getAirPollution(double lat, double lon) async {
    print('lat $lat lon $lon');
    NetworkHelper networkHelper = NetworkHelper(
        '$baseAPI/air_pollution?lat=${lat}&lon=${lon}&appid=$apiKey&units=metric');
    var airPollutionResponse = await networkHelper.getData();

    return airPollutionResponse;
  }

  String getPollutionIcon(double pm2_5) {
    if (pm2_5 < 10) {
      return '😀';
    } else if (pm2_5 < 25) {
      return '🙂';
    } else if (pm2_5 < 50) {
      return '😷';
    } else if (pm2_5 < 75) {
      return '😧';
    } else if (pm2_5 >= 75) {
      return '😖';
    } else {
      return '🤷‍';
    }
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

  String getPollutionMessage(int index) {
    if (index == 1) {
      return 'Good air';
    } else if (index == 2) {
      return 'Fair air';
    } else if (index == 3) {
      return 'Moderate air';
    } else {
      return 'You\'ll need to use a air pollution masks';
    }
  }
}

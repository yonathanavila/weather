import 'package:flutter/material.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.locationWeather, required this.airPollution});

  final locationWeather;
  final airPollution;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late int temperature;
  late String zoneName;
  late int condition;

  late double pm2_5; // PM 2.5 air pollution
  late int aqi; // Air quality index

  WeatherModel weatherModel = WeatherModel();
  late String weatherIcon;
  late String weatherMessage;

  late String pollutionIcon;
  late String pollutionMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather, widget.airPollution);
  }

  void updateUI(dynamic weatherData, dynamic airPollutionData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get the weather data!';
        zoneName = '';
        return;
      }

      if (airPollutionData == null) {
        pollutionIcon = "Error";
        pollutionMessage = "Unable to get the pollution data!";
        return;
      }

      var temp = (weatherData['main']['temp']);
      temperature = temp.toInt();
      condition = weatherData['weather'][0]['id'];
      zoneName = weatherData['name'];

      weatherIcon = weatherModel.getWeatherIcon(condition);
      weatherMessage = weatherModel.getMessage(temperature);

      var _pollutionData = airPollutionData['list'][0];
      var _pm2_5 = _pollutionData['components']['pm2_5'];
      pm2_5 = _pm2_5;
      aqi = _pollutionData['main']['aqi'];
      pollutionIcon = weatherModel.getPollutionIcon(pm2_5);
      pollutionMessage = weatherModel.getPollutionMessage(aqi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var (weatherData, airPollutionData) =
                          await weatherModel.getLocationWeather();
                      updateUI(weatherData, airPollutionData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var (weatherData, airPollutionData) = await weatherModel
                            .getLocationWeatherByName(typedName);

                        updateUI(weatherData, airPollutionData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            '$temperature°',
                            style: kTempTextStyle,
                          ),
                          Text(
                            weatherIcon,
                            style: kConditionTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PM 2.5 ',
                                style: kPollVarLabelTextStyle,
                              ),
                              Text(
                                'Air Pollution',
                                style: kPollutionLabelTextStyle,
                              )
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ' ${(pm2_5).toStringAsFixed(1)} ',
                                  style: kPollTextStyle,
                                ),
                                Text(
                                  pollutionIcon,
                                  style: kPollIconTextStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                pollutionMessage,
                                style: kPollutionMessageTextStyle,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $zoneName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:weather/screens/location_screen.dart';
import 'package:weather/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationWeather();
  }

  void getLocationWeather() async {
    var weatherResponse = await WeatherModel().getLocationWeather();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return LocationScreen(
          locationWeather: weatherResponse,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SpinKitThreeBounce(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
                decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ));
          },
          size: 50.0,
        ));
  }

  @override
  void dispose() {
    // Cleanup resources here
    super.dispose();
    print("exit");
  }
}

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/screens/location_screen.dart';
import 'package:weather/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:weather/services/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var apiKey = dotenv.env['OPEN_WEATHER_API_KEY'];

class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude = 0;
  late double longitude = 0;

  @override
  void initState() {
    super.initState();
    getLocationWeather();
  }

  void getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;

    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    var weatherResponse = await networkHelper.getData();



    Navigator.push(context, MaterialPageRoute(builder: (context){
        return LocationScreen(locationWeather: weatherResponse,);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitThreeBounce(
        itemBuilder: (BuildContext context, int index){
          return DecoratedBox(decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
            shape: BoxShape.circle,
          ));
        },
        size: 50.0,
      )
    );
  }

  @override
  void dispose() {
    // Cleanup resources here
    super.dispose();
    print("exit");
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/services/location.dart';
import 'package:http/http.dart' as http;


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async{
    Location location = Location();
    await location.getCurrentLocation();
    print(location.latitude);
    print(location.longitude);
  }

  void getWeather() async{
    double temperature;
    String zoneName;
    int condition;

    //API JEY ddfab6f954ca6f94d38ae3b694287540
    try {
      Future<http.Response> fetchAlbum() async{
        return http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=ddfab6f954ca6f94d38ae3b694287540'));
      }
      final data = await fetchAlbum();

      if(data.statusCode != 200){
        print(data.statusCode);
      }

      var response = jsonDecode(data.body);

      temperature = response["main"]["temp"];
      condition = response["weather"][0]["id"];
      zoneName = response["name"];
      print(temperature.toString() + " " + condition.toString() + " " + zoneName);

    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    getWeather();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: Text('Get Location'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cleanup resources here
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/services/location.dart';

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

  @override
  Widget build(BuildContext context) {
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

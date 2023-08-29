// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false;
  double? latitude;
  double? longitude;
  handleLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission accepted');
    } else {
      print('Location permission denied');
    }
    setState(() {
      _isLoading = true;
    });

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    setState(() {
      _isLoading = false;
    });

    print("Latitude: $latitude, Longitude: $longitude");
  }

  @override
  void initState() {
    handleLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Location Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? const CircularProgressIndicator()
                  : longitude != null && longitude != null
                      ? Column(
                          children: [
                            Text("Latitude: $latitude"),
                            Text("Longitude: $longitude"),
                          ],
                        )
                      : const Text(
                          'Track your location here by clicking button below.',
                        ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  handleLocation();
                },
                child: const Text('Track Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

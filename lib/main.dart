// ignore_for_file: prefer_const_constructors, prefer_const_declarations, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
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

  Future<void> postData() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'https://7tonexpress.com/locationtesting/update?id=1&lat=$latitude&lon=$longitude';

    Map<String, dynamic> data = {
      'id': '3',
    };

    print('post started');

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final request = await client.postUrl(Uri.parse(apiUrl));
    request.headers.add('Accept', '/');

    request.write(jsonEncode(data));

    final response = await request.close();

    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      print('Response data: $responseBody');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response data: $responseBody');
    }

    print(response.statusCode);
    print('post end');
    setState(() {
      _isLoading = false;
    });
  }

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
    postData();
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
                onPressed: () async {
                  await handleLocation();
                  postData();
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

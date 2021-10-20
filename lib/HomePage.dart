import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = 'Baku';
  int derece = 25;
  var locationData;
  var woeid;
  Future<void> getLocationTemperature() async {
    var response = await http.get(
        'https://www.metaweather.com/api/location/search/location/$woeid/');
    var temperatureDataParsed = jsonDecode(response.body);
    var temp = temperatureDataParsed['consolidated_weather'][0]['the_temp'];
    print(temp);
  }

  Future<void> getLocationData() async {
    locationData = await http
        .get('https://www.metaweather.com/api/location/search/?query=london');
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
  }

  void getDataAPI() async {
    await getLocationData();
    getLocationTemperature();
  }

  @override
  void initState() {
    getDataAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/c.jpg'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$derece°C',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$city',
                    style: TextStyle(fontSize: 30),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

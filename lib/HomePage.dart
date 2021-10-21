import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = 'oslo';
  int derece;
  var locationData;
  var woeid;
  String img = 'c';
  Position position;
  List imgs = List(5);
  List temps = List(5);
  List dates = List(5);

  Future<void> getDevicePosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
  }

  Future<void> getLocationTemperature() async {
    var response = await http.get(
        'https://www.metaweather.com/api/location/search/location/$woeid/');
    var temperatureDataParsed = jsonDecode(response.body);
    // derece = temperatureDataParsed['consolidated_weather'][0]['the_temp'];

    setState(() {
      for (int i = 0; i < 5; i++) {
        temps[i] = temperatureDataParsed['consolidated_weather'][i + 1]
                ['the_temp']
            .round();
        imgs[i] = temperatureDataParsed['consolidated_weather'][i + 1]
            ['weather_state_abbr'];
        dates[i] = temperatureDataParsed['consolidated_weather'][i + 1]
            ['applicable_date'];
      }

      derece =
          temperatureDataParsed['consolidated_weather'][0]['the_temp'].round();
      img = temperatureDataParsed['consolidated_weather'][0]
          ['weather_state_abbr'];
    });
  }

  Future<void> getLocationData() async {
    locationData = await http
        .get('https://www.metaweather.com/api/location/search/?query=$city');
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
  }

  Future<void> getLocationLatLong() async {
    locationData = await http.get(
        'https://www.metaweather.com/api/location/search/?lattlong=${position.latitude},${position.longitude}');
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
    city = locationDataParsed[0]['title'];
  }

  void getDataAPI() async {
    await getDevicePosition();
    await getLocationLatLong();
    getLocationTemperature();
  }

  void getDataAPICity() async {
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
          image: AssetImage('assets/$img.jpg'),
        ),
      ),
      child: derece == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/$img.png'),
                    ),
                    Text(
                      '$derece°C',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 70,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(-4, 10),
                              blurRadius: 5,
                            )
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$city',
                          style: TextStyle(fontSize: 30, shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(-2, 5),
                              blurRadius: 5,
                            )
                          ]),
                        ),
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () async {
                              city = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));
                              getDataAPICity();
                              setState(() {
                                city = city;
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return DailiyWeather(
                            image: imgs[index],
                            date: dates[index],
                            temp: temps[index].toString(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class DailiyWeather extends StatelessWidget {
  final String image;
  final String temp;
  final String date;

  const DailiyWeather({Key key, this.image, this.temp, this.date})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Container(
        width: 120,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.metaweather.com/static/img/weather/png/$image.png',
              height: 50,
              width: 50,
            ),
            Text(
              '$temp°C',
            ),
            Text(
              '$date',
            ),
          ],
        ),
      ),
    );
  }
}

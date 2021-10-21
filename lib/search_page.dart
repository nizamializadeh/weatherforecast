import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final mycontroller = TextEditingController();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Wrong City Choose"),
          content: new Text("Please select a valid city"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/search.jpg'),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: mycontroller,
                  decoration: InputDecoration(
                      hintText: 'Choose City',
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var response = await http.get(
                        'https://www.metaweather.com/api/location/search/?query=${mycontroller.text}');
                    jsonDecode(response.body).isEmpty
                        ? _showDialog()
                        : Navigator.pop(context, mycontroller.text);
                  },
                  child: Text('Chooshe City'))
            ],
          ),
        ),
      ),
    );
  }
}

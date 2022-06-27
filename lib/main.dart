import 'package:flutter/material.dart';
// To remove # at the end of redirect url when in web mode (not mobile)
// This is a web only package
// import 'dart:html' as html;

// import 'package:example/examples.dart';

// import 'package:example/secret.dart';

// import 'package:example/permissions.dart';

import 'package:strava_flutter/strava.dart';

// Used by example

import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/API/activities.dart';
import 'package:strava_flutter/Models/club.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_flutter/Models/gear.dart';
import 'package:strava_flutter/Models/runningRace.dart';
import 'package:strava_flutter/Models/stats.dart';
import 'package:strava_flutter/Models/summaryAthlete.dart';
import 'package:strava_flutter/Models/zone.dart';
import 'package:strava_flutter/Models/fault.dart';

import './secret.dart';

Strava? strava;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strava Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StravaFlutterPage(title: 'Strava Flutter Demo'),
    );
  }
}

class StravaFlutterPage extends StatefulWidget {
  const StravaFlutterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _StravaFlutterPageState createState() => _StravaFlutterPageState();
}

class _StravaFlutterPageState extends State<StravaFlutterPage> {
  @override
  void initState() {
    setState(() {
      // html.window.history.pushState(null, "home", '/');
    });
    super.initState();
  }

  void exampleStrava() {
    example(secret);
  }
  

  void example(String secret) async {
    bool isAuthOk = false;

    final strava = Strava(true, secret);
    final prompt = 'auto';

 
    isAuthOk = await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    if (isAuthOk) {

      // ////////////////////////////////////////Create an new activity/////////////////////////////////////////////

      final _startDate = DateTime.now();
      DetailedActivity _newActivity = await strava.createActivity(
          'Insane Fitness',
          'Workout',
          _startDate.toString(),
          360,
          distance: 155,
          description: 'This is a strava_flutter test');
      if (_newActivity.fault.statusCode != 201) {
        print(
            'Error in createActivity ${_newActivity.fault.statusCode}  ${_newActivity.fault.message}');
      } else {
        print('createActivity  ${_newActivity.name}');
      }

      // Type of expected answer:
      // {"id":25707617,"username":"patrick_ff","resource_state":3,"firstname":"Patrick","lastname":"FF",
      // "city":"Le Beausset","state":"Provence-Alpes-Côte d'Azur","country":"France","sex":null,"premium"
      DetailedAthlete _athlete = await strava.getLoggedInAthlete();
      if (_athlete.fault.statusCode != 200) {
        print(
            'Error in getloggedInAthlete ${_athlete.fault.statusCode}  ${_athlete.fault.message}');
      } else {
        print('getLoggedInAthlete ${_athlete.firstname}  ${_athlete.lastname}');
      }
      
    }
  }

  void deAuthorize() async {
    // need to get authorized before (valid token)
    final strava = Strava(
      true, // to get disply info in API
      secret, // Put your secret key in secret.dart file
    );
    var fault = await strava.deAuthorize();
  }

  @override
  // void dispose() {
  //   strava.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              key: const Key('OthersButton'),
              onPressed: exampleStrava,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // This is what you need!
              ),
              child: const Text(
                'Create Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              key: const Key('DeAuthorizeButton'),
              onPressed: deAuthorize,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // This is what you need!
              ),
              child: const Text(
                'DeAuthorize',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

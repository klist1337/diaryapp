
import 'package:flutter/material.dart';

const auth0Domain = "dev-kfabv157h1pldych.us.auth0.com";
const auth0ClientId = "30Dqzo0KAWDh6lRRq9g9zL07l1dg9Qqe";


const  List<Map<String, dynamic>> feelings = 
  [ {"feeling":"Happy", "icon": Icon(Icons.sentiment_very_satisfied, color: Colors.yellow,)},
    {"feeling": "Bad" ,"icon": Icon(Icons.sentiment_neutral, color: Colors.greenAccent,) },
    {"feeling":"Fearful","icon": Icon(Icons.sentiment_neutral, color: Colors.orange)},
    {"feeling":"Angry", "icon":Icon(Icons.sentiment_neutral, color: Colors.red)},
    {"feeling":"Disgusted","icon": Icon(Icons.sentiment_neutral, color: Colors.grey)},
    {"feeling":"Suprised", "icon":Icon(Icons.sentiment_neutral, color: Colors.purple)},
    {"feeling":"Sad","icon": Icon(Icons.sentiment_very_dissatisfied, color: Colors.blueAccent)},
    {"feeling":"Sick", "icon":Icon(Icons.sick, color: Colors.pink)},
    ];
List<Map<String, dynamic>> iconColors = [
      {"feeling": "Happy", "color": Colors.yellow},
      {"feeling": "Bad", "color": Colors.greenAccent},
      {"feeling": "Fearful", "color": Colors.orange},
      {"feeling": "Angry", "color": Colors.red},
      {"feeling": "Disgusted", "color": Colors.grey},
      {"feeling": "Suprised", "color": Colors.purple},
      {"feeling": "Sad", "color": Colors.blueAccent},
      {"feeling": "Sick", "color": Colors.pink}
    ];
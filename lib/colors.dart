import 'package:flutter/material.dart';

class ColorsManager {

  // Colors

  static final Map<Color, String> colorToString = {
    Colors.white: 'white',
    Colors.blue: 'blue',
    Colors.lightBlueAccent: 'lightBlueAccent',
    Colors.blueAccent: 'blueAccent',
    Colors.yellow: 'yellow',
    Colors.yellowAccent: 'yellowAccent',
    Colors.green: 'green',
    Colors.greenAccent: 'greenAccent',
    Colors.pink: 'pink',
    Colors.pinkAccent: 'pinkAccent',
    Colors.purple: 'purple',
    Colors.deepPurpleAccent: 'deepPurpleAccent',
    Colors.purpleAccent: 'purpleAccent',
    Colors.orange: 'orange',
    Colors.deepOrange: 'deepOrange',
    Colors.red: 'red',
    Colors.redAccent: 'redAccent',
    Colors.grey: 'grey',
    Colors.blueGrey: 'blueGrey',
    Colors.black: 'black'
  };

  static final Map<String,Color> stringToColor = {
    'white': Colors.white,
    'blue': Colors.blue,
    'lightBlueAccent': Colors.lightBlueAccent,
    'blueAccent': Colors.blueAccent,
    'yellow': Colors.yellow,
    'yellowAccent': Colors.yellowAccent,
    'green': Colors.green,
    'greenAccent': Colors.greenAccent,
    'pink': Colors.pink,
    'pinkAccent': Colors.pinkAccent,
    'purple': Colors.purple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'purpleAccent': Colors.purpleAccent,
    'orange': Colors.orange,
    'deepOrange': Colors.deepOrange,
    'red': Colors.red,
    'redAccent': Colors.redAccent,
    'grey': Colors.grey,
    'blueGrey': Colors.blueGrey,
    'black': Colors.black
  };

  static String getStringFromColor(Color color){
    return colorToString[color] ?? 'white';
  }

  static Color getColorFromString(String colorName) {
    return stringToColor[colorName] ?? Colors.black;
  }
}
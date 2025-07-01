import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> with SingleTickerProviderStateMixin  {

  //Le temps

  late Timer _timer;
  late DateTime _currentTime;
  final String localLanguageUser = 'fr_FR'; //On note la langue du user en dure pour le premier dev

  late DateFormat jourFormat;
  late DateFormat horlogeFormat;


  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    jourFormat = DateFormat.yMMMMEEEEd(localLanguageUser);
    horlogeFormat  = DateFormat('HH:mm:ss',localLanguageUser);
    _tick();
  }

  void _tick(){
    setState(() {
      _currentTime = DateTime.now();
    });
    int delay = 1000 - _currentTime.millisecond;
    _timer = Timer(Duration(milliseconds: delay), _tick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(horlogeFormat.format(_currentTime), style: Theme
            .of(context)
            .textTheme
            .displayMedium
            ?.copyWith(fontWeight: FontWeight.w300, color: Theme
            .of(context)
            .colorScheme
            .onSurface)
          ),
          Text(jourFormat.format(_currentTime).toUpperCase(), style: Theme
            .of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Theme
            .of(context)
            .colorScheme
            .onSurfaceVariant)
          ),
      ]
    );
  }
}

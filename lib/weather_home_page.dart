import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_application/constants.dart';
import 'package:weather_application/weather_home_body.dart';
import 'package:intl/intl.dart'; 


class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {


  String _selectedUnit = "Istanbul";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: DigitalClock(),
        centerTitle: true,
        leadingWidth: 100,
        leading: _LeadingMenu(
          currentCity: _selectedUnit,
          onCitySelected: (String value) {
            setState(() {
              _selectedUnit = value;
            });
          }
        ),
      ),

      body: WeatherHomeBody(cityName: _selectedUnit),
      
    );
  }
}

class _LeadingMenu extends StatefulWidget {
  const _LeadingMenu({super.key, required this.currentCity, required this.onCitySelected});

  final String currentCity;
  final Function(String) onCitySelected;

  @override
  State<_LeadingMenu> createState() => _LeadingMenuState();
}

class _LeadingMenuState extends State<_LeadingMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
          onSelected: widget.onCitySelected,
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              Text(widget.currentCity, style: const TextStyle(fontSize: AppSizes.fontSmall, fontWeight: FontWeight.bold)),
            ],
          ),
          itemBuilder: (context) => [
            CheckedPopupMenuItem(
              value: "Istanbul",
              checked: widget.currentCity == "Istanbul",
              child: Text("Istanbul"),
            ),
            CheckedPopupMenuItem(
              value: "Denizli",
              checked: widget.currentCity == "Denizli",
              child: Text("Denizli"),
            ),
          ],
        );
  }
}

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {

  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    final int secondsUntilNextMinute = 60 - _now.second;

    Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
      setState(() {
        _now = DateTime.now();
      });
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {
          _now = DateTime.now();
        });
      });
    });
  }

  String get _formattedDate {
    return DateFormat('EEEE, MMM d').format(_now);
  }
  String get _formattedTime {
    return DateFormat('HH.mm').format(_now);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Text(_formattedDate, style: const TextStyle(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
              Text("$_formattedTime GMT+3",style: const TextStyle(fontSize: AppSizes.fontSmall, fontWeight: FontWeight.bold)),
            ],
          );
  }
}
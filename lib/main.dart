import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/weather/weather_event.dart';
import 'package:weather_app/weather_helper/weather_helper.dart';
import 'repositories/weather_repository.dart';
import 'blocs/weather/weather_bloc.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository = WeatherRepository();
  final LocationService locationService = LocationService(); // Add this

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create:
            (_) => WeatherBloc(
              weatherRepository,
              locationService,
            ), // Fixed this line
        child: Builder(
          builder: (context) {
            context.read<WeatherBloc>().add(FetchWeatherByLocation());
            return WeatherScreen();
          },
        ),
      ),
    );
  }
}

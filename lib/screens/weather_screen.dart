import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/weather/weather_bloc.dart';
import '../blocs/weather/weather_event.dart';
import '../blocs/weather/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Weather App'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your location',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.read<WeatherBloc>().add(
                        FetchWeather(_controller.text),
                      );
                    },
                    icon: Icon(Icons.search),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return const Center(child: Text('Enter a city to begin'));
                  } else if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getIcon(state.weather.main),
                        Text(
                          state.weather.cityName,
                          style: const TextStyle(fontSize: 22),
                        ),
                        Text('${state.weather.temperature.toInt()} °C'),
                        Text(state.weather.main),
                        Text(state.weather.description),
                        Text('Humidity: ${state.weather.humidity}%'),
                        Text(
                          'Wind Speed: ${state.weather.windSpeed.toInt()} km/h',
                        ),

                        Text(
                          getCurrentTime(state.weather.dateTime),
                          style: TextStyle(fontSize: 16),
                        ),
                        FaIcon(FontAwesomeIcons.wind, color: Colors.blue),
                        FaIcon(FontAwesomeIcons.water, color: Colors.blue),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getCurrentTime(var dt) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
    dt * 1000,
    isUtc: true,
  );

  // Format to 12-hour time like "5:01 PM"
  String formattedTime = DateFormat.jm().format(
    dateTime.toLocal(),
  ); // convert to local time

  print(formattedTime); // Output: e.g., "5:01 PM"
  final now = DateTime.now();
  return DateFormat('h:mm a').format(now);
}

Widget getIcon(String weatherState) {
  final hour = DateTime.now().hour;
  final isNight = hour < 6 || hour >= 18;
  switch (weatherState) {
    case 'Clear':
      return isNight
          ? FaIcon(FontAwesomeIcons.moon, color: Colors.blue)
          : FaIcon(FontAwesomeIcons.sun, color: Colors.blue);
    case 'Clouds':
      return FaIcon(FontAwesomeIcons.cloudSun, color: Colors.blue);
    case 'Rain':
    case 'Drizzle':
      return FaIcon(FontAwesomeIcons.cloudSunRain, color: Colors.blue);
    case 'Snow':
      return FaIcon(FontAwesomeIcons.snowflake, color: Colors.blue);
    case 'Thunderstorm':
      return FaIcon(FontAwesomeIcons.cloudBolt, color: Colors.blue);
    case 'Haze':
    case 'Mist':
      return FaIcon(FontAwesomeIcons.smog, color: Colors.blue);
    default:
      return isNight
          ? FaIcon(FontAwesomeIcons.moon, color: Colors.blue)
          : FaIcon(FontAwesomeIcons.sun, color: Colors.blue);
  }
}

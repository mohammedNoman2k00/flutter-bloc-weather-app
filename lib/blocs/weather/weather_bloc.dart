import 'package:flutter_bloc/flutter_bloc.dart';

import 'weather_event.dart';
import 'weather_state.dart';
import '../../weather_helper/weather_helper.dart';
import '../../repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  final LocationService locationService;

  WeatherBloc(this.repository, this.locationService) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await repository.fetchWeather(event.city);
        emit(WeatherLoaded(weather));
      } catch (_) {
        emit(WeatherError('Could not fetch weather for ${event.city}'));
      }
    });

    on<FetchWeatherByLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        final position = await locationService.getCurrentLocation();
        final weather = await repository.fetchWeatherByLocation(
          position.latitude,
          position.longitude,
        );
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Could not fetch weather by location'));
      }
    });
  }
}

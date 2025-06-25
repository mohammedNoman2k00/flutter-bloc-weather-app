class Weather {
  final String main;
  final int humidity;
  final int dateTime;
  final String cityName;
  final double windSpeed;
  final double temperature;
  final String description;

  Weather({
    required this.main,
    required this.cityName,
    required this.dateTime,
    required this.humidity,
    required this.windSpeed,
    required this.temperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      dateTime: json['dt'],
      cityName: json['name'],
      main: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}

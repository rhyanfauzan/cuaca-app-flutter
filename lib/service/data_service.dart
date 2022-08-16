import 'dart:convert';

import 'package:cuaca_app/model/weather.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<Weather> fetchData(String cityName) async {
    try {
      // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
      final queryParamaters = {
        'q': cityName,
        'appid': '2b888f2903b03f7acab3c7e3eea64988',
        'units': 'imperial',
      };
      final uri = Uri.https(
          'api.openweathermap.org', '/data/2.5/weather', queryParamaters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('failed to load weather');
      }
    } catch (e) {
      rethrow;
    }
  }
}

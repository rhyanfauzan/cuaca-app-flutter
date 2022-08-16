class Weather {
  final String name;
  final String description;
  final String icon;
  final double temp;

  Weather(
      {this.name = 'Nama Cuaca',
      this.description = 'Kondisi',
      this.icon = '',
      this.temp = 0});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['name'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      temp: json['main']['temp'] ?? 0,
    );
  }
}

/*
{
  "weather": [
    {
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "main": {
    "temp": 282.55,
  },
  "name": "Mountain View",
  }                         
 */
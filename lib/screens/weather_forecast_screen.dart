import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/api/weather_api.dart';
import 'package:weather/models/weather_forecast_daily.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/widgets/bottom_list_view.dart';
import 'package:weather/widgets/city_view.dart';
import 'package:weather/widgets/datail_view.dart';
import 'package:weather/widgets/temp_view.dart';

class WeatherForecastSkreen extends StatefulWidget {
   final locationWeather;
   WeatherForecastSkreen({this.locationWeather});

  @override
  State<WeatherForecastSkreen> createState() => _WeatherForecastSkreenState();
}

class _WeatherForecastSkreenState extends State<WeatherForecastSkreen> {
  late Future<WeatherForecast> forecastObject;
  String _cityName = 'London';
  // late String _cityName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.locationWeather != null){
      forecastObject =
          WeatherApi().fetchWeatherForecast();
    }


    // forecastObject.then((weather) {
    //   print(weather.list![0].weather![0].main);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "openweathermap.org",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              forecastObject = WeatherApi().fetchWeatherForecast();
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
            var tappedName =  await Navigator.push(context, MaterialPageRoute(builder: (context){
                return CityScreen();
              }));
              if (tappedName != null){
                setState(() {
                  _cityName = tappedName;
                  forecastObject = WeatherApi().fetchWeatherForecast(city: _cityName , isCity: true);
                });
              }
            },
            icon: Icon(
              Icons.location_city,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: FutureBuilder<WeatherForecast>(
              future: forecastObject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 50,),
                      CityView(snapshot: snapshot),
                      const SizedBox(height: 50,),
                      TempView(snapshot: snapshot),
                      const SizedBox(height: 50,),
                      DetailView(snapshot: snapshot),
                      const SizedBox(height: 50,),
                      BottomListView(snapshot: snapshot),
                    ],
                  );
                } else {
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.black87,
                      size: 100.0,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

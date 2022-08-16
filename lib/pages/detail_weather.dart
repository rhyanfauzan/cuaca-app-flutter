import 'package:cuaca_app/model/weather.dart';
import 'package:cuaca_app/service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DetailWheater extends StatefulWidget {
  // const DetailWheater({Key? key}) : super(key: key);

  String? value;
  DetailWheater({this.value});

  @override
  State<DetailWheater> createState() => _DetailWheaterState(value);
}

class _DetailWheaterState extends State<DetailWheater> {
  TextEditingController controller = TextEditingController();
  DataService dataService = DataService();
  Weather weather = Weather();
  final controllerName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? value;
  String? namaKota = '';
  _DetailWheaterState(this.value);

  bool isFetch = false;

  @override
  Widget build(BuildContext context) {
    String greetingMessage() {
      var timeNow = DateTime.now().hour;

      if (timeNow <= 12) {
        return 'Pagi';
      } else if ((timeNow > 12) && (timeNow <= 16)) {
        return 'Siang';
      } else if ((timeNow > 16) && (timeNow < 20)) {
        return 'Sore';
      } else {
        return 'Malam';
      }
    }

    String suhuToStringAsFixed(double suhu, int afterDecimal) {
      return '${suhu.toString().split('.')[0]}.${suhu.toString().split('.')[1].substring(0, afterDecimal)}';
    }

    var suhu = (weather.temp - 32) * 5 / 9;
    print(suhuToStringAsFixed(suhu, 2));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat.yMMMMEEEEd().format(DateTime.now()),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Selamat ${greetingMessage()}, ${value}!',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 22),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: controller,
                          onChanged: (text) {
                            namaKota = text;
                          },
                          validator: (value) =>
                              value == '' ? 'kota harus diisi.' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              // fillColor: AppColor.primary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'masukan nama kota',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueAccent.shade200),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color:
                                                Colors.blueAccent.shade200)))),
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );

                                isFetch = true;

                                weather = await dataService
                                    .fetchData(controller.text);
                                setState(() {});
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Text('Submit'),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  isFetch
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(color: Colors.blue, spreadRadius: 3),
                            ],
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: [
                                Text(
                                  'Kota ${namaKota}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Image.network(
                                    'http://openweathermap.org/img/wn/${weather.icon}@2x.png'),
                                Text(
                                  // (X °F − 32) × 5/9 = X °C
                                  '${suhuToStringAsFixed(suhu, 2)} °C',
                                  style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  weather.description,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          'Silahkan masukan nama kota terlebih dahlulu! :)',
                          style: TextStyle(color: Colors.black),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/logo_jds.png',
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Aplikasi ini dibuat untuk Test software junior programming',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

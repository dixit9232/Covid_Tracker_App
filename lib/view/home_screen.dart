import 'dart:convert';

import 'package:covid_tracker_app/model/AllCountryDataModel.dart';
import 'package:covid_tracker_app/url/app_api.dart';
import 'package:covid_tracker_app/view/country_list.dart';
import 'package:covid_tracker_app/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(seconds: 3))
        ..repeat();

  Map m = {};

  Future GetAllCountriesData() async {
    var url = Uri.parse(AppApi.all);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      m = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Please Check Internet');
    }
  }

  List<Color> ColorList = [Colors.blue, Colors.green, Colors.red];

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return ConnectivityBuilder(interval: Duration(hours: 24),
      builder: (status) {
        if (status == ConnectivityStatus.online) {
          return Scaffold(
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FutureBuilder(
                      future: GetAllCountriesData(),
                      builder: (context, snapshot) {
                        print(snapshot.connectionState);
                        AllCountryDataModel allCountryDataModel =
                            AllCountryDataModel.fromJson(m);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SpinKitCircle(
                                color: Colors.green,
                                size: h * 0.1,
                                controller: controller),
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              PieChart(
                                colorList: ColorList,
                                dataMap: {
                                  'Total': double.parse(
                                      allCountryDataModel.cases.toString()),
                                  'Recovered': double.parse(
                                      allCountryDataModel.recovered.toString()),
                                  'Deaths': double.parse(
                                      allCountryDataModel.deaths.toString()),
                                },
                                legendOptions: LegendOptions(
                                    legendPosition: LegendPosition.left),
                                chartType: ChartType.ring,
                                chartValuesOptions: ChartValuesOptions(
                                    showChartValuesInPercentage: true),
                                chartRadius: w * 0.3,
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    ReusableRow.name("Total Cases",
                                        allCountryDataModel.cases.toString()),
                                    ReusableRow.name(
                                        "Total Recovered",
                                        allCountryDataModel.recovered
                                            .toString()),
                                    ReusableRow.name("Total Deaths",
                                        allCountryDataModel.deaths.toString()),
                                    ReusableRow.name("Active Cases",
                                        allCountryDataModel.active.toString()),
                                    ReusableRow.name(
                                        "Critical Cases",
                                        allCountryDataModel.critical
                                            .toString()),
                                    ReusableRow.name("Tasets",
                                        allCountryDataModel.tests.toString()),
                                    ReusableRow.name(
                                        "Today Cases",
                                        allCountryDataModel.todayCases
                                            .toString()),
                                    ReusableRow.name(
                                        "Today Recovered",
                                        allCountryDataModel.todayRecovered
                                            .toString()),
                                    ReusableRow.name(
                                        "Today Deaths",
                                        allCountryDataModel.todayDeaths
                                            .toString()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(w, h * 0.05))),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return CountryList();
                                      },
                                    ), (route) => true);
                                  },
                                  child: Text("Track Countries"))
                            ],
                          );
                        }
                      },
                    ))),
          );
        } else if(status==ConnectivityStatus.offline){
          return NoInternet();
        }
        else{
        return  CheckInternet();
        }
      },
    );
  }
}
class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(body: SafeArea(child: Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4,color: Colors.red.withOpacity(0.5),
              size: h * 0.09,
            ),
            SizedBox(width: w*0.05,),
            Text("No Internet Connection",textAlign: TextAlign.center,style: TextStyle(fontSize:20 ,color: Colors.grey.withOpacity(0.7)),)
          ]),
    )),);
  }
}

class CheckInternet extends StatelessWidget {
  const CheckInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SpinKitCircle(
              color: Colors.green,
              size: h * 0.1,),
        ),
      ),
    );
  }
}


class ReusableRow extends StatelessWidget {
  String title, value;

  ReusableRow.name(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(
            height: h * 0.02,
          ),
          Divider()
        ],
      ),
    );
  }
}

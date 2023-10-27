import 'package:covid_tracker_app/model/CoutriesModel.dart';
import 'package:covid_tracker_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

class CountryDetails extends StatefulWidget {
  var map;

  CountryDetails(this.map);

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    CoutriesModel countriesModel = CoutriesModel.fromJson(widget.map);
    return ConnectivityBuilder(interval: Duration(hours: 24),
      builder: (status) {
        if (status == ConnectivityStatus.online) {
          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(countriesModel.country.toString())),
            body: SafeArea(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.topCenter, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.07),
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          ReusableRow.name(
                              'Total Cases', countriesModel.cases.toString()),
                          ReusableRow.name('Total Recovered',
                              countriesModel.recovered.toString()),
                          ReusableRow.name(
                              'Total Deaths', countriesModel.deaths.toString()),
                          ReusableRow.name(
                              'Active Cases', countriesModel.active.toString()),
                          ReusableRow.name('Today Cases',
                              countriesModel.todayCases.toString()),
                          ReusableRow.name('Today Recoverd',
                              countriesModel.todayRecovered.toString()),
                          ReusableRow.name('Today Deaths',
                              countriesModel.todayDeaths.toString()),
                        ],
                      )),
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          countriesModel.countryInfo!.flag.toString()),
                    ),
                  ]),
                ],
              ),
            )),
          );
        } else if(status==ConnectivityStatus.offline){
          return NoInternet();
        }
        else{
          return CheckInternet();
        }
      },
    );
  }
}

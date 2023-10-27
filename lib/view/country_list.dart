import 'dart:convert';

import 'package:covid_tracker_app/model/CoutriesModel.dart';
import 'package:covid_tracker_app/url/app_api.dart';
import 'package:covid_tracker_app/view/CountryDetails.dart';
import 'package:covid_tracker_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:shimmer/shimmer.dart';

class CountryList extends StatefulWidget {
  const CountryList({super.key});

  @override
  State<CountryList> createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  TextEditingController searchController = TextEditingController();
  List l = [];
  var keyword;

  Future GetCountriesApi() async {
    var url = Uri.parse(AppApi.single);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      l = jsonDecode(response.body);
    } else {
      throw Exception('Please Check Internet');
    }
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
    if(status==ConnectivityStatus.online){
      return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(w * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    child: TextField(onChanged: (value) {
                      keyword=value;
                      setState(() {

                      });
                    },
                      controller: searchController,onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          hintText: "Search Country",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Expanded(
                      child: FutureBuilder(
                        future: GetCountriesApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            print(snapshot.connectionState);
                            return Shimmer(gradient: LinearGradient(colors: [Colors.grey.shade700,Colors.grey.shade100]),
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Container(width: w*0.17,height: h*0.15,color: Colors.white),
                                      title: Container(width: w*0.05,height: 20,color: Colors.white),
                                      subtitle: Container(width: w*0.7,height: 15,color: Colors.white),
                                    );
                                  },
                                ));
                          } else {
                            return ListView.builder(
                              itemCount: l.length,
                              itemBuilder: (context, index) {
                                CoutriesModel country=CoutriesModel.fromJson(l[index]);
                                String name= country.country.toString();
                                if(searchController.text.isEmpty){
                                  return ListTile(onTap: () {
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => CountryDetails(l[index]),), (route) => true);
                                  },
                                    leading: Image.network(country.countryInfo!.flag.toString(),width: w*0.17,height: h*0.15),
                                    title: Text(country.country.toString()),
                                    subtitle: Text(country.cases.toString()),
                                  );
                                }
                                else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                                  return ListTile(onTap: () {
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => CountryDetails(l[index]),), (route) => true);
                                  },
                                    leading: Image.network(country.countryInfo!.flag.toString(),width: w*0.17,height: h*0.15),
                                    title: Text(country.country.toString()),
                                    subtitle: Text(country.cases.toString()),
                                  );
                                }
                                else{
                                  return Container();
                                }
                              },
                            );
                          }
                        },
                      ))
                ],
              ),
            )),
      );
    }
    else if(status==ConnectivityStatus.offline)
      {
        return NoInternet();
      }
    else{
      return CheckInternet();
    }
  },);
  }
}

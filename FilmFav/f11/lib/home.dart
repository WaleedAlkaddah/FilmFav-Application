import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_log/quick_log.dart';
import 'details_popular.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'model/popular.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<GetPopularData> popularObj = [];
  final log = const Logger('Home');

  Future fetchDataPopular() async {
    log.info("Start fetchData_Popular", includeStackTrace: false);

    EasyLoading.show(status: 'loading...');
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=23829d5b3c662d6f6d6d978adecfa756');
    final response = await http.get(url);
    final data = json.decode(response.body);
    log.fine("fetchData_Popular : $data", includeStackTrace: false);

    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Success");
      setState(() {
        popularObj = List<GetPopularData>.from(
          data['results'].map((result) => GetPopularData.fromJson(result)),
        );
      });
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError("Failed");
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 275),
              child: Text(
                "Popular",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 620,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 20, bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 25,
                      childAspectRatio: 0.6),
                  itemCount: popularObj.length,
                  itemBuilder: (BuildContext contex, int index) {
                    final gData = popularObj[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPopular(
                                      detail: gData,
                                    )),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w200${gData.posterPath}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: Text(
                                          'Failed to load image from Server',
                                          style: TextStyle(color: Colors.black),
                                        ));
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                gData.originalTitle,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

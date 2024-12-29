import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:quick_log/quick_log.dart';
import 'details_popular.dart';
import 'model/popular.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final search = TextEditingController();
  final log = const Logger('Search');

  var popularObj = <GetPopularData>[];
  String selectedValue = "Language";

  Future post(String query) async {
    log.info("Start Fetch Data", includeStackTrace: false);
    EasyLoading.show(status: 'loading...');
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=23829d5b3c662d6f6d6d978adecfa756&query=$query&language=$selectedValue&page=1');
    var response = await http.get(url);
    var data = json.decode(response.body);
    log.info("fetchData_Search : $data", includeStackTrace: false);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Success");
      EasyLoading.dismiss();
      setState(() {
        popularObj = List<GetPopularData>.from(
            data['results'].map((result) => GetPopularData.fromJson(result)));
      });
    } else {
      EasyLoading.showError("Failed");
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              onChanged: (value) {},
              onSubmitted: (value) {
                log.fine("value $value", includeStackTrace: false);
                post(value.toString());
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 25,
                childAspectRatio: 0.6,
              ),
              itemCount: popularObj.length,
              itemBuilder: (context, index) {
                final result = popularObj[index];
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
                                  detail: result,
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
                              'https://image.tmdb.org/t/p/w200${result.posterPath}',
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
                            result.originalTitle,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:f11/details_book.dart';
import 'package:flutter/material.dart';
import 'package:quick_log/quick_log.dart';
import 'model/popular.dart';
import 'model/storage.dart';
import 'package:http/http.dart' as http;

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  List<String> data = [];
  List<GetPopularData> popularObj = [];
  String clicked = "";
  final log = const Logger('Search');

  getData() async {
    data = await StorageShared.getData();
    log.info(data, includeStackTrace: false);
    setState(() {});
  }

  Future post(String queryId) async {
    try {
      log.info("Start Fetch Data", includeStackTrace: false);
      Uri url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$queryId?api_key=23829d5b3c662d6f6d6d978adecfa756');
      var response = await http.get(url);
      final data = json.decode(response.body);
      log.info("fetchData_Search : $data", includeStackTrace: false);
      if (response.statusCode == 200) {
        log.info("fetchData_Search : $data", includeStackTrace: false);

        GetPopularData popularObj1 = GetPopularData.fromJson(data);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsBook(
                    detail: popularObj1,
                  )),
        );
      }
    } catch (ex) {
      log.error("object $ex", includeStackTrace: false);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void clicke(String x) {
    setState(() {
      clicked = x;
      log.info(clicked, includeStackTrace: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              StorageShared.clearData();

              setState(() {
                getData();
              });
            },
            child: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final item = data[index];
            bool isNumber = int.tryParse(item) != null;
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: isNumber ? Text(item) : null,
                    //leading: is_number ? null : Text(item),
                    onTap: () {
                      if (isNumber) {
                        log.info("Clicked in number $item",
                            includeStackTrace: false);
                        post(item.toString());
                      }
                    },
                  ),
                ),
                Expanded(
                    child: ListTile(
                  title: isNumber ? null : Text(item),
                ))
              ],
            );
          }),
    );
  }
}

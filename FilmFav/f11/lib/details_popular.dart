import 'package:flutter/material.dart';
import 'package:quick_log/quick_log.dart';
import 'model/popular.dart';
import 'model/storage.dart';

class DetailsPopular extends StatefulWidget {
  final GetPopularData detail;
  const DetailsPopular({super.key, required this.detail});

  @override
  State<DetailsPopular> createState() => _DetailsPopularState();
}

class _DetailsPopularState extends State<DetailsPopular> {
  List<String> value = [];
  final log = const Logger('DetailsPopular');

  void addValue(List<String> items) {
    setState(() {
      value.addAll(items);
      log.info(value, includeStackTrace: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w200${widget.detail.posterPath}"),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: InkWell(
              child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all()),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              onTap: () => {Navigator.pop(context)},
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, -4),
                        blurRadius: 8,
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.detail.originalTitle.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Popularity",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Language",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.detail.popularity,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              widget.detail.originalLanguage,
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.detail.overview,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: MaterialButton(
                          color: Colors.red,
                          minWidth: 150,
                          onPressed: () {
                            List<String> data = [
                              widget.detail.id.toString(),
                              widget.detail.originalTitle.toString()
                            ];
                            StorageShared.storeData(data);
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ]),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

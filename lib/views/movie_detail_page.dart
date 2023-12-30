import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/moive.dart';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetail? movieDetail;
  bool isLoading = true;
  final String imgBasePath =
      '${ApiConfig.tmdbApiImageBaseUrl}${ApiConfig.tmdbApiImageSizeBackdrop}/';

  @override
  void initState() {
    super.initState();
    fetchMovieDetail();
  }

  Future<void> fetchMovieDetail() async {
    final response = await http.get(
      Uri.parse(ApiConfig.tmdbApiMovieDetail(widget.movieId.toString())),
    );

    if (response.statusCode == 200) {
      setState(() {
        movieDetail = MovieDetail.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      // Handle error or set a state to show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                // Background image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(ApiConfig.tmdbApiMovieBackdrop(
                          movieDetail!.backdropPath!)),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                    decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                )),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Top back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          // Handle back action
                          Navigator.pop(context);
                        },
                      ),
                      // Center play button and movie details
                      Positioned(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // 电影信息
                            Text(
                              movieDetail?.getFormattedDateAndRuntime() ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4.0), // 添加一点垂直间距
                            // 电影标题
                            Text(
                              movieDetail?.title ?? "",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4.0), // 添加一点垂直间距
                            // 类型标签
                            Text(
                              movieDetail?.getFormattedGenres() ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4.0), // 添加一点垂直间距
                          ],
                        ),
                      ),
                      // Bottom icons and labels
                    ],
                  ),
                ),
              ],
            ),
          ),
          Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.transparent,
                    Color.fromARGB(255, 211, 15, 15),
                  ])),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  // 电影简介
                  Text(
                    movieDetail?.overview ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Text("test2"),
                ])),
          ]),
        ],
      ),
    );
  }
}

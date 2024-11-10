import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadb/screens/search_screen.dart';
import 'package:quadb/share/constant_variable.dart';

class DetailsScreen extends StatefulWidget {
  final int videoId;

  const DetailsScreen({super.key, required this.videoId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? videoDetails;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows/${widget.videoId}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        videoDetails = data;
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(videoDetails?['name'] ?? 'Loading...'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchScreen()));
              },
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
      body: videoDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    videoDetails!['image'] != null
                        ? CachedNetworkImage(
                            imageUrl: videoDetails!['image']['original'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : CachedNetworkImage(
                            imageUrl: ConstantVariable.noThumbnailAvailable,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                    const SizedBox(height: 16),
                    Text(
                      videoDetails!['name'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text("Language: ${videoDetails!['language']}"),
                    Text('genres: ${videoDetails!['genres']}'),
                    Text("status: ${videoDetails!['status']}"),
                    Text(
                        "runTime: ${videoDetails!['runtime']}, averageRunTime: ${videoDetails!['averageRuntime']}"),
                    Text(
                        "premiered: ${videoDetails!['premiered']}, ended: ${videoDetails!['ended']}"),
                    Text("Link: ${videoDetails!['url']}"),
                    Text("official site: ${videoDetails!['officialSite']}"),
                    Text(
                        "Schedule => Time : ${videoDetails!['schedule']['time']}, days: ${videoDetails!['schedule']['days']}"),
                    Text(
                        "Rating => average: ${videoDetails!['rating']['average']}"),
                    Text("Weight: ${videoDetails!['weight']}"),
                    Text("Updated: ${videoDetails!['updated']}"),
                    const SizedBox(height: 8),
                    Text(
                      "Summary: ${videoDetails!['summary'] ?? 'No available'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

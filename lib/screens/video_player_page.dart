import 'package:film_sales_service/models/film.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  final Film film;

  const VideoPlayerPage({Key key, this.film}) : super(key: key);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

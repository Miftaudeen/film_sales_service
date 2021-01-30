import 'package:film_sales_service/models/film.dart';
import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/screens/edit_film.dart';
import 'package:film_sales_service/screens/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final Film film;
  final User user;

  const VideoItem({Key key, this.film, this.user}) : super(key: key);
  @override
  State<VideoItem> createState() => _VideoItemState(this.film, this.user);
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;
  final Film film;
  final User user;

  _VideoItemState(this.film, this.user);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.film.downloadLink)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          elevation: 4,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).buttonColor),
              borderRadius: BorderRadius.circular(5)),
          child: Container(
            child: Column(children: [
              _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      width: size.width,
                      height: 200,
                      child: Image.asset(
                        film.banner,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
              ListTile(
                title: Text(
                  film.title,
                  style: textTheme.headline5,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(film.description, style: textTheme.subtitle1),
                    Text.rich(TextSpan(text: "Price: ", children: [
                      TextSpan(text: "\u{20A6}"),
                      TextSpan(
                          text: "${film.price}",
                          style: Theme.of(context).textTheme.subtitle1),
                    ]))
                  ],
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                  child: user?.role == Role.admin
                      ? IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditFilm(film: film))),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.monetization_on,
                            color: Colors.green,
                          ),
                        ),
                ),
              )
            ]),
          ),
        ),
        user?.role == Role.admin
            ? Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => null,
                    )),
              )
            : Container()
      ],
    );
  }
}

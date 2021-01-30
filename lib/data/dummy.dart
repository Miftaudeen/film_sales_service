import 'package:film_sales_service/models/film.dart';
import 'package:film_sales_service/models/genre.dart';

class Dummy {
  static const List<Film> FILM_ITEMS = [
    Film(
        title: "Venom: Let There Be Carnage",
        description:
            "Venom: Let There Be Carnage is an upcoming American superhero film based on the Marvel Comics character Venom, produced by Columbia Pictures in association with Marvel and Tencent Pictures",
        price: 2500,
        genre: Genre(name: "Adventure/Superhero"),
        director: "Andy Serkis",
        label: "Columbia Pictures",
        downloadLink:
            "https://ccc.bindex.xyz/download/5e4a2867eb5904799d8dfd6ea0de734a",
        banner: "assets/images/venom.jpeg",
        year: "2021"),
    Film(
        title: "Master",
        description:
            "An alcoholic professor is sent to a juvenile school, where he clashes with a gangster who uses the school's children for criminal activities",
        price: 1500,
        genre: Genre(name: "Drama/Mystery"),
        director: "Lokesh Kanagaraj",
        downloadLink:
            "https://ccc.bindex.xyz/download/5e4a2867eb5904799d8dfd6ea0de734a",
        banner: "assets/images/master.jpg",
        year: "2021"),
    Film(
        title: "The Eternals",
        description:
            "The saga of the Eternals, a race of immortal beings who lived on Earth and shaped its history and civilisations.",
        price: 1700,
        genre: Genre(name: "Action/Fantasy"),
        director: "Chloé Zhao",
        label: "Marvel",
        downloadLink:
            "https://ccc.bindex.xyz/download/5e4a2867eb5904799d8dfd6ea0de734a",
        banner: "assets/images/eternals.jpg",
        year: "2021"),
    Film(
        title: "Tenet",
        description:
            "A secret agent is given a single word as his weapon and sent to prevent the onset of World War III. He must travel through time and bend the laws of nature in order to be successful in his mission.",
        price: 1600,
        director: "Christopher Nolan",
        label: "Warner Bros Pictures",
        genre: Genre(name: "Action/Sci-fi"),
        downloadLink:
            "https://ccc.bindex.xyz/download/5e4a2867eb5904799d8dfd6ea0de734a",
        year: "2020",
        banner: "assets/images/tenet.jpg"),
    Film(
        title: "The Way Back",
        description:
            "Jack Cunningham was a high school basketball superstar who suddenly walked away from the game for unknown reasons. Years later, he's now stuck in a meaningless job and struggling with alcoholism - the very thing that ruined his marriage and his hope for a better life. But Jack soon gets a shot at redemption when he becomes the basketball coach for his alma mater, a programme that has fallen on hard times since his teenage glory days.",
        price: 2450,
        director: "Gavin O'Connor",
        genre: Genre(name: "Sport/Drama"),
        label: "Warner Bros Pictures",
        year: "2020",
        downloadLink:
            "https://ccc.bindex.xyz/download/5e4a2867eb5904799d8dfd6ea0de734a",
        banner: "assets/images/the_way_back.jpg"),
  ];
}

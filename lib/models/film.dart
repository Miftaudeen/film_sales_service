import 'package:film_sales_service/models/genre.dart';

class Film {
  final String title;
  final String director;
  final String year;
  final double price;
  final Genre genre;
  final int rating;
  final int format;
  final String label;
  final String banner;
  final String description;
  final String downloadLink;

  const Film(
      {this.title,
      this.director,
      this.year,
      this.price,
      this.genre,
      this.rating,
      this.format,
      this.label,
      this.banner,
      this.downloadLink,
      this.description});
}

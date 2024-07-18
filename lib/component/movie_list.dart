import 'package:flutter/material.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Film Name'),
      subtitle: Text('jsdjsjadlksdfjl'),
    );
  }
}

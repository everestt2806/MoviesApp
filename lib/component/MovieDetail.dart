import 'package:flutter/material.dart';
import 'package:movies_app/Db/DbService.dart';
import 'package:movies_app/Models/Movie.dart';

class MovieDetail extends StatefulWidget {
  final int? id;

  const MovieDetail({required this.id});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  DbService _dbService = DbService();
  late Movie mv = Movie.defaultConstructor();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final Movie movie = await _dbService.getMovieDetails(widget.id!);
    setState(() {
      mv = movie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: mv.posterPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${mv.posterPath}',
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      );
                    },
                  )
                : Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 50,
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mv.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  mv.genreIds.join(', '),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Xem phim'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, size: 24),
                          SizedBox(width: 8),
                          Text('Yêu thích'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:movies_app/Db/DbService.dart';
import 'package:movies_app/Models/Movie.dart';

class MovieProvider with ChangeNotifier {
  final DbService _apiService = DbService();
  List<Movie> _movies = [];
  Movie _movie = Movie.defaultConstructor();
  List<Movie> get movies => _movies;

  Future<List<Movie>?> fetchNowPlayingMovies() async {
    try {
      final movies = await _apiService.getNowPlayingMovies();
      return movies;
    } catch (error) {
      print("Error fetching movies: $error");
      return null;
    }
  }

  Future<Movie?> fetchMovieDetail(int id) async{
     try{
       final _movie = await _apiService.getMovieDetail(id);
       return _movie;
     }
     catch(error){
       print("Error fetching movies: $error");
       return null;
     }
  }




// Thêm các phương thức khác để tương tác với API
}
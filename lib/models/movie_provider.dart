import 'package:flutter/foundation.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final APIService _apiService = APIService();
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
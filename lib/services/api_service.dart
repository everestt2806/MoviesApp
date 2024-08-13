import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/movie.dart';

class APIService {
  final String apiKey = '438ccfd2ebf05c9a60b29043e01880d2';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<dynamic> getMovieGenres() async {
    final response = await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US'));
    return json.decode(response.body);
  }

  Future<List<Movie>> searchKeyword(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/keyword?api_key=$apiKey&page=1&query=$query'));
    return json.decode(response.body);
  }

  Future<Movie?> getMovieDetail(int id) async {
    final url = '$baseUrl/movie/$id?api_key=$apiKey&append_to_response=videos';

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return Movie.fromJson(data);
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return null;
      } catch (e) {
        print('Error fetching movie detail: $e');
        return null;
      }
    } else {
      print('Failed to load movie detail (Status code: ${response.statusCode})');
      return null;
    }
  }


  Future<List<Movie>?> getNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=438ccfd2ebf05c9a60b29043e01880d2&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        return results?.map((movieData) => Movie.fromJson(movieData)).toList();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return null;
      } catch (e) {
        print('Error fetching movies: $e');
        return null;
      }
    } else {
      throw Exception('Failed to load now playing movies (Status code: ${response.statusCode})');
    }
  }

// Thêm các phương thức khác cho các API còn lại
}
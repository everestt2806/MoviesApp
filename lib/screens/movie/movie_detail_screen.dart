import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/services/api_service.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  MovieDetailPage({
    required this.id,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Movie _movie = Movie.defaultConstructor();
  APIService _apiService = APIService();
  bool _isLoading = true;  // Biến để kiểm soát trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    fetchMovieDetail(widget.id);
  }

  void fetchMovieDetail(int id) async {
    final Movie? mv = await _apiService.getMovieDetail(id);
    if (mv != null) {
      setState(() {
        _movie = mv;
        _isLoading = false;  // Đánh dấu rằng dữ liệu đã được tải
      });
    } else {
      print("Movie not found");
      setState(() {
        _isLoading = false;  // Ngừng trạng thái tải ngay cả khi không tìm thấy phim
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading  // Kiểm tra trạng thái tải dữ liệu
          ? Center(child: CircularProgressIndicator())  // Hiển thị chỉ báo tiến trình khi đang tải dữ liệu
          : CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_movie.title),
              background: Image.network(
                'https://image.tmdb.org/t/p/w500${_movie.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${_movie.posterPath}',
                          height: 180,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Release Date: ${_movie.releaseDate}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star, color: Colors.amber),
                                Text(' ${_movie.voteAverage}/10'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton.icon(
                                  icon: Icon(Icons.play_arrow),
                                  label: Text('Watch'),
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.file_download),
                                  label: Text('Download'),
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8),
                      Text(_movie.overview),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            icon: Icon(Icons.favorite_border),
                            label: Text('Add to Favorites'),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<int> genreIds;
  final double popularity;
  final DateTime releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final String originalLanguage;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.originalLanguage,
  });

  // Default constructor with no parameters
  Movie.defaultConstructor()
      : id = 0,
        title = '',
        originalTitle = '',
        overview = '',
        posterPath = '',
        backdropPath = '',
        genreIds = [],
        popularity = 0.0,
        releaseDate = DateTime.now(),
        video = false,
        voteAverage = 0.0,
        voteCount = 0,
        adult = false,
        originalLanguage = '';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids']),
      popularity: json['popularity'].toDouble(),
      releaseDate: DateTime.parse(json['release_date']),
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
      adult: json['adult'],
      originalLanguage: json['original_language'],
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<int> genreIds;
  final double popularity;
  final DateTime? releaseDate;
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
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      genreIds: (json['genres'] as List<dynamic>?)
          ?.map((genre) => genre['id'] as int)
          .toList() ?? [],
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date']!= null ? DateTime.tryParse(json['release_date']) : null,
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
    );
  }
}

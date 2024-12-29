class GetPopularData {
  final String id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String originalLanguage;
  final String popularity;
  final String voteAverage;
  final String releaseDate;
  final String backdropPath;

  GetPopularData({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.originalLanguage,
    required this.popularity,
    required this.voteAverage,
    required this.releaseDate,
    required this.backdropPath,
  });

  factory GetPopularData.fromJson(Map<String, dynamic> json) {
    return GetPopularData(
      id: json['id'].toString(),
      originalTitle: json['original_title'],
      overview: json['overview'],
      originalLanguage: json['original_language'],
      popularity: json['popularity'].toString(),
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toString(),
      posterPath: json['poster_path']?.toString() ?? "",
      backdropPath: json['backdrop_path']?.toString() ?? "",
    );
  }
}

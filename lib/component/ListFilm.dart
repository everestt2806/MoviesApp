import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<Map<String, String>> movies = [
    {
      'title': 'Chìa Khóa Trăm Tỷ',
      'image': 'assets/banner/ChiaKhoaTramTy.jpg',
      'genre': 'Hài hước',
      'rating': '7.5',
    },
    {
      'title': 'Chị Mẹ Học Yêu 2',
      'image': 'assets/banner/ChiMeHocYeu2.jpg',
      'genre': 'Tình cảm',
      'rating': '8.0',
    },
    {
      'title': 'My Hero Academia: World Heroes Mission',
      'image': 'assets/banner/MyHeroAcademiaWorldHeroesMission.jpg',
      'genre': 'Hoạt hình',
      'rating': '8.5',
    },
    {
      'title': 'Doctor Strange in the Multiverse of Madness',
      'image': 'assets/banner/DoctorStrangeInTheMultiverseOfMadness.jpg',
      'genre': 'Hành động, Phiêu lưu',
      'rating': '9.0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 150,
                child: Image(
                  image: AssetImage(movies[index]['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movies[index]['title']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Thể loại: ${movies[index]['genre']}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(' ${movies[index]['rating']}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
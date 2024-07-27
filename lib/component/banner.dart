import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {

  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final List<Movie>? movies = await provider.fetchNowPlayingMovies();
    setState(() {
      _movies = movies!;
    });
  }
  int _currentIndex = 0;
  final List<List<String>> _imageList = [
    ['assets/banner/ChiaKhoaTramTy.jpg', 'assets/banner/ChiMeHocYeu2.jpg'],
    ['assets/banner/MyHeroAcademiaWorldHeroesMission.jpg', 'assets/banner/DoctorStrangeInTheMultiverseOfMadness.jpg'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 350.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _imageList.map((imagePair) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    children: imagePair.map((imageName) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                              image: AssetImage(imageName),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 5),
        DotsIndicator(
          dotsCount: _imageList.length,
          position: _currentIndex.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(20.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}
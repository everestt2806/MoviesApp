import 'package:flutter/material.dart';
import 'package:movies_app/component/ListFilm.dart';
import 'component/banner.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      )
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                BannerSlider(),
                SizedBox(height: 5,),
              ],
            ),
          ),
          SliverFillRemaining(
            child: MovieList(),
          ),
        ],
      ),
    );
  }
}
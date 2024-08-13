import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/models/movie_provider.dart';
import 'package:movies_app/screens/movie/movie_list_screen.dart';
import 'package:movies_app/widgets//Banner.dart';
import 'package:movies_app/widgets/SearchBar.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'Search',
    'Favorite',
    'Download',
  ];

  final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    SearchContent(),
    FavoriteContent(),
    DownloadContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          _titles[_selectedIndex],
          colors: [
            Color(0xFF00BFFF),  // Deep Sky Blue
            Color(0xFF10AAF7),  // 25% gradient
            Color(0xFF2094F0),  // 50% gradient
            Color(0xFF317FE8),  // 75% gradient
            Color(0xFF4169E1),  // Royal Blue
          ],
          style: TextStyle(
            fontFamily: 'Calistoga',
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4E54C8),
                Color(0xFF8F94FB),
              ],
            ),
          ),
        ),
        WeatherBg(
          weatherType: WeatherType.heavySnow,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 1), // Thêm padding ở đây
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            label: 'Download',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BannerSlider(), // Cố định ở đầu
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 1000, // Đặt chiều cao cố định
                  child: MovieList(),
                ),
                // Thêm các widget khác ở đây nếu cần
              ],
            ),
          ),
        ),
      ],
    );
  }
}
  class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: SearchBar());
  }
}

class FavoriteContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Favorite Content'));
  }
}

class DownloadContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Download Content'));
  }
}

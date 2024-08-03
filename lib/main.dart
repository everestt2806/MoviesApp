import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/Models/MovieProvider.dart';
import 'package:movies_app/component/MovieList.dart';
import 'package:movies_app/component/Banner.dart';
import 'package:movies_app/component/SearchBar.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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
            Color(0xFF00c6ff),
            Color(0xFF0072ff),
            Color(0xFF6a82fb),
            Color(0xFFFC466B),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFff7e5f),
              Color(0xFFfeb47b),
              Color(0xFFFFE3AC)
            ],
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 50),
          Container(
            child: BannerSlider(),
          ),
          Container(
            height: 500, // Hoặc một giá trị phù hợp
            child: MovieList(),
          ),
        ],
      ),
    );
  }
}
class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:  SearchBar());
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
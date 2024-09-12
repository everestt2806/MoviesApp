import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/models/movie_provider.dart';
import 'package:movies_app/screens/movie/movie_list_screen.dart';
import 'package:movies_app/widgets//Banner.dart';
import 'package:movies_app/widgets/SearchBar.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:movies_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Kiểm tra xem Firebase đã được khởi tạo chưa
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyDCQSocHlcHwznstM5mMHJQbO84YF5y7x4",
          appId: "1:916601440407:android:078e2f118dd07beffec1d2",
          messagingSenderId: "916601440407",
          projectId: "movieapp-83f81",
          databaseURL: "https://movieapp-83f81-default-rtdb.firebaseio.com",
        ),
      );
    } else {
      Firebase.app();
    }
  } catch (e) {
    print('Lỗi khởi tạo Firebase: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
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

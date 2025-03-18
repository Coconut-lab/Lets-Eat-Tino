import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/navigation_controller.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/bookmark_screen.dart';
import 'views/screens/search_screen.dart';
import 'views/screens/user_screen.dart';
import 'views/widgets/custom_app_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lets eat tino',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    BookMarkScreen(),
    SearchScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: controller.selectedIndex == 3
              ? CustomAppBar.userScreenAppBar()
              : CustomAppBar.defaultAppBar(),
          body: Container(
            color: Colors.white,
            child: _screens[controller.selectedIndex],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context, controller),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, NavigationController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          color: Colors.grey[400],
        ),
        SizedBox(
          height: 80,
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex,
            onTap: (index) => controller.updateIndex(index),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            iconSize: 35,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                activeIcon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

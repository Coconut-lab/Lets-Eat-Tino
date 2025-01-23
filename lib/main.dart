import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    BookMarkScreen(),
    SearchScreen(),
    UserScreen(),
  ];

  final AppBar defaultAppBar = AppBar(
    toolbarHeight: 100,
    elevation: 0,
    backgroundColor: Colors.white,
    flexibleSpace: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/LetsEatTino.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '000님 환영해요!',
                style: GoogleFonts.doHyeon(
                  textStyle: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Image.asset(
                'assets/User1.png',
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  final AppBar userScreenAppBar = AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    toolbarHeight: 100,
    elevation: 0,
    flexibleSpace: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 10),
        Image.asset(
          'assets/LetsEatTino.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
      ],
    ),
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 3 ? userScreenAppBar : defaultAppBar,
      body: Container(
        color: Colors.white,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Column의 높이를 최소화
        children: [
          // 구분선
          Container(
            height: 1,
            color: Colors.grey[400], // 밝은 회색 라인
          ),
          // BottomNavigationBar
          SizedBox(
            height: 80,
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
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
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          Image.asset(
            'assets/MainTino.png',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bookmark Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _recentSearches = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _topSearches = [
    "닭꼬치",
    "낙곱새",
    "파닭",
    "꼬치",
    "타코야끼",
    "야식",
  ];

  void _addSearch(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 8) {
          _recentSearches.removeLast();
        }
      });
      _searchController.clear();
    }
  }

  void _removeSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat('yyyy.MM.dd HH:mm').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Search Bar
          TextField(
            controller: _searchController,
            onSubmitted: _addSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '검색어를 입력하세요',
              hintStyle: GoogleFonts.doHyeon(
                textStyle: TextStyle(fontSize: 16),
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xffE3E3E3),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
          ),
          const SizedBox(height: 16),
          // Recent Searches
          Text(
            '최근 검색어',
            style: GoogleFonts.doHyeon(
              textStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 검색 기록 표시
          SizedBox(
            height: 40, // 일정한 높이 설정
            child: _recentSearches.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 수평 스크롤 활성화
                    child: Row(
                      children: _recentSearches.map((query) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0), // 칩 간 간격
                          child: Chip(
                            label: Text(query),
                            deleteIcon: Icon(Icons.close),
                            onDeleted: () => _removeSearch(query),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '최근 검색 기록이 없습니다.',
                      style: GoogleFonts.doHyeon(
                          textStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
          ),
          const SizedBox(height: 16), // 일정한 간격 유지
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Top6 인기 검색어',
                style: GoogleFonts.doHyeon(
                    textStyle: TextStyle(fontSize: 18), color: Colors.black),
              ),
              const SizedBox(width: 7),
              Text(
                '$currentDate 기준',
                style: GoogleFonts.doHyeon(
                    textStyle: TextStyle(fontSize: 12), color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xffE3E3E3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: GoogleFonts.doHyeon(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _topSearches[index],
                                  style: GoogleFonts.doHyeon(
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            if (index < 2) const SizedBox(height: 8),
                          ],
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (index) {
                        final adjustedIndex = index + 3;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${adjustedIndex + 1}.',
                                  style: GoogleFonts.doHyeon(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _topSearches[adjustedIndex],
                                  style: GoogleFonts.doHyeon(
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            if (index < 2) const SizedBox(height: 8), // 순위 간 간격
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('tuk 제휴업체',
              style: GoogleFonts.doHyeon(
                  textStyle: TextStyle(fontSize: 18), color: Colors.black)),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}

Widget _buildChip(String label) {
  return Chip(
    label: Text(
      label,
      style: GoogleFonts.doHyeon(),
    ),
    deleteIcon: Icon(Icons.close),
    onDeleted: () {
      // Handle delete action
    },
  );
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'User Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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

  List<Partner> _partners = [];

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    final String response = await rootBundle.loadString('assets/partners.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _partners = data.map((json) => Partner.fromJson(json)).toList();
    });
  }

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

    return SingleChildScrollView(
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
          SizedBox(
            height: 40,
            child: _recentSearches.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _recentSearches.map((query) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
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
          const SizedBox(height: 16),
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
                            if (index < 2) const SizedBox(height: 8),
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
          // tuk 제휴업체 섹션
          Text('tuk 제휴업체',
              style: GoogleFonts.doHyeon(
                  textStyle: TextStyle(fontSize: 18), color: Colors.black)),
          const SizedBox(height: 16),
          _partners.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 180,
                  width: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _partners.length,
                    itemBuilder: (context, index) {
                      final partner = _partners[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color(0xffE3E3E3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // 내부 여백 추가
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // 이미지
                                Container(
                                  height: 80, // 박스의 절반 정도 높이
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(10), // 상단 모서리 둥글게
                                    image: DecorationImage(
                                      image: AssetImage(partner.image),
                                      fit: BoxFit.cover, // 이미지를 박스에 꽉 채움
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 업체 이름
                                Text(partner.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.doHyeon(
                                        textStyle: TextStyle(fontSize: 18),
                                        color: Colors.black)),
                                const SizedBox(height: 8),
                                // 혜택과 조건
                                Align(
                                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 텍스트 정렬
                                    children: [
                                      Text(
                                        "혜택: ${partner.benefit}",
                                        style: GoogleFonts.doHyeon(
                                            textStyle: TextStyle(fontSize: 14)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "조건: ${partner.condition}",
                                        style: GoogleFonts.doHyeon(
                                            textStyle: TextStyle(fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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

class Partner {
  final String image;
  final String name;
  final String benefit;
  final String condition;

  Partner({
    required this.image,
    required this.name,
    required this.benefit,
    required this.condition,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      image: json['image'],
      name: json['name'],
      benefit: json['benefit'],
      condition: json['condition'],
    );
  }
}

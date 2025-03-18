import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../models/partner_model.dart';

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
  List<Partner> _filteredPartners = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadPartners();
    _searchController.addListener(() {
      _filterPartners(_searchController.text);
    });
  }

  Future<void> _loadPartners() async {
    final String response = await rootBundle.loadString('assets/partners.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _partners = data.map((json) => Partner.fromJson(json)).toList();
      _filteredPartners = _partners;
    });
  }

  void _filterPartners(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredPartners = _partners;
      } else {
        _filteredPartners = _partners
            .where((partner) =>
                partner.name.toLowerCase().contains(query.toLowerCase()) ||
                partner.benefit.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
      _filterPartners('');
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
          _buildSearchBar(),
          if (!_isSearching) ...[
            const SizedBox(height: 16),
            _buildRecentSearches(),
            const SizedBox(height: 16),
            _buildTopSearches(currentDate),
          ],
          const SizedBox(height: 16),
          _buildPartnersList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onSubmitted: _addSearch,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _isSearching
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterPartners('');
                },
              )
            : null,
        hintText: '검색어를 입력하세요',
        hintStyle: GoogleFonts.doHyeon(
          textStyle: const TextStyle(fontSize: 16),
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xffE3E3E3),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 검색어',
          style: GoogleFonts.doHyeon(
            textStyle: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: _recentSearches.isNotEmpty
              ? _buildRecentSearchList()
              : _buildEmptyRecentSearches(),
        ),
      ],
    );
  }

  Widget _buildRecentSearchList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _recentSearches.map((query) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                _searchController.text = query;
                _filterPartners(query);
              },
              child: Chip(
                label: Text(query),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => _removeSearch(query),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyRecentSearches() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '최근 검색 기록이 없습니다.',
        style: GoogleFonts.doHyeon(
          textStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTopSearches(String currentDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Top6 인기 검색어',
              style: GoogleFonts.doHyeon(
                textStyle: const TextStyle(fontSize: 18),
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$currentDate 기준',
              style: GoogleFonts.doHyeon(
                textStyle: const TextStyle(fontSize: 12),
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTopSearchesGrid(),
      ],
    );
  }

  Widget _buildTopSearchesGrid() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xffE3E3E3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            for (int column = 0; column < 2; column++)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (row) {
                    final index = column * 3 + row;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          _searchController.text = _topSearches[index];
                          _filterPartners(_topSearches[index]);
                        },
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: GoogleFonts.doHyeon(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'tuk 제휴업체',
          style: GoogleFonts.doHyeon(
            textStyle: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        _partners.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredPartners.length,
                  itemBuilder: (context, index) {
                    return _buildPartnerCard(_filteredPartners[index]);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildPartnerCard(Partner partner) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xffE3E3E3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(partner.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                partner.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.doHyeon(
                  textStyle: const TextStyle(fontSize: 18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "혜택: ${partner.benefit}",
                      style: GoogleFonts.doHyeon(
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "조건: ${partner.condition}",
                      style: GoogleFonts.doHyeon(
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

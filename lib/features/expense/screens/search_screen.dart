import 'dart:async';

import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/expense/widgets/search/empty_search_state.dart';
import 'package:expense_tracker/features/expense/widgets/search/no_results_state.dart';
import 'package:expense_tracker/features/expense/widgets/search/search_bar_widget.dart';
import 'package:expense_tracker/features/expense/widgets/search/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 검색 화면
class SearchScreen extends ConsumerStatefulWidget {
  /// 검색 화면 생성자
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  var _searchQuery = '';
  List<Expense> _searchResults = [];
  var _isSearching = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// 디바운싱을 적용한 검색 실행
  void _performSearch(String query) {
    // 이전 타이머 취소
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchQuery = query;
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    // 300ms 후에 검색 실행
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final repository = ref.read(expenseRepositoryProvider);
        final results = await repository.searchByTitleOrMemo(query);

        if (mounted) {
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        }
      } on Exception catch (_) {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      }
    });
  }

  /// 검색 결과 위젯 빌드
  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return const EmptySearchState();
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return NoResultsState(searchQuery: _searchQuery);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final expense = _searchResults[index];
        return SearchResultItem(
          expense: expense,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(
                  mode: Edit(expense, expense.emotion),
                ),
              ),
            );
            // 수정 후 돌아왔을 때 검색 결과 다시 로드
            if (mounted && _searchQuery.isNotEmpty) {
              _performSearch(_searchQuery);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '검색',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: systemBarsPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 입력 필드 (위젯으로 분리)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: _performSearch,
                onClear: () {
                  _searchController.clear();
                  _performSearch('');
                },
              ),
            ),

            // 검색 결과 헤더
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  '검색 결과',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),

            // 검색 결과 목록
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }
}

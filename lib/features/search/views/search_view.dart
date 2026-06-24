// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_router.dart';
import '../../../features/favourites/controllers/favourites_controller.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../controllers/search_controller.dart' as feature_search;
import '../widgets/search_result_tile.dart';
import '../widgets/search_skeleton.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final feature_search.SearchController _controller;
  late final FavouritesController _favouritesController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<feature_search.SearchController>();
    _favouritesController = Get.find<FavouritesController>();
    _textController = TextEditingController(text: _controller.query.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes')),
      body: Column(
        children: <Widget>[
          // أول جزء من الشاشة هو حقل البحث، حيث يمكن للمستخدم كتابة استعلام البحث. هذا الحقل مرتبط بالـ Controller ليتفاعل معه مباشرة.
          Obx(() {
            if (_textController.text != _controller.query.value) {
              _textController.value = TextEditingValue(
                text: _controller.query.value,
                selection: TextSelection.collapsed(
                  offset: _controller.query.value.length,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: TextField(
                controller: _textController,
                onChanged: _controller.onQueryChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search meals by name...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controller.query.value.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _textController.clear();
                            _controller.clearQuery();
                          },
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Clear',
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              final String trimmedQuery = _controller.query.value.trim();

              if (_controller.isLoading.value) {
                return const SearchSkeleton();
              }

              if (_controller.errorMessage.value.isNotEmpty) {
                return AppErrorState(
                  title: 'Search failed',
                  message: _controller.errorMessage.value,
                  onRetry: _controller.retry,
                );
              }

              if (trimmedQuery.isEmpty) {
                return const AppEmptyState(
                  title: 'Start Searching',
                  message: 'Type at least 2 letters to search meals.',
                  icon: Icons.search_rounded,
                );
              }

              if (!_controller.hasEnoughCharacters) {
                return const AppEmptyState(
                  title: 'Keep Typing',
                  message: 'Please enter at least 2 characters.',
                  icon: Icons.keyboard_rounded,
                );
              }

              if (_controller.results.isEmpty) {
                return const AppEmptyState(
                  title: 'No Results',
                  message: 'No meals matched your query. Try another keyword.',
                  icon: Icons.manage_search_rounded,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: _controller.results.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final meal = _controller.results[index];

                  return Obx(
                    () => SearchResultTile(
                      meal: meal,
                      isFavourite: _favouritesController.isFavourite(meal.id),
                      onToggleFavourite: () {
                        _favouritesController.toggleFavouriteMeal(meal);
                      },
                      onTap: () {
                        context.go(
                          '${AppRoutes.home}/meal/${Uri.encodeComponent(meal.id)}',
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

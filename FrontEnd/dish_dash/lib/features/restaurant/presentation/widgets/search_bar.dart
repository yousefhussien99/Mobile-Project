import 'package:flutter/material.dart';
import '../screens/product_search_results.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final Function(bool) onFocusChanged;
  final List<String> suggestions;
  final bool isSearchFocused;
  final Map<String, List<String>> popularSearchesWithTags;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    required this.onFocusChanged,
    required this.suggestions,
    required this.isSearchFocused,
    required this.popularSearchesWithTags,
    this.hintText = 'Search on DishDash',
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  // Default popular searches (used as fallback)
  final Map<String, List<String>> _defaultPopularSearches = {
    "Grilled chicken": ["Chicken", "Grilled", "Main Course"],
    "Pasta": ["Italian", "Main Course", "Vegetarian"],
    "Sushi": ["Japanese", "Seafood", "Healthy"],
    "Club sandwiches": ["Sandwich", "Lunch", "Quick Meal"],
    "Cheesecake": ["Dessert", "Sweet", "Bakery"],
  };

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      widget.onFocusChanged(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToSearchResults(String query) {
    _focusNode.unfocus();
    widget.onFocusChanged(false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductSearchResultsScreen(
          searchQuery: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularSearches = widget.popularSearchesWithTags.isNotEmpty
        ? widget.popularSearchesWithTags
        : _defaultPopularSearches;

    return Column(
      children: [
        // Search Bar with Button
        Row(
          children: [
            // Search Bar
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _navigateToSearchResults(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            // Search Button
            const SizedBox(width: 8),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFC23435),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _navigateToSearchResults(_controller.text);
                  } else {
                    // Navigate to search screen without query
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductSearchResultsScreen(
                          searchQuery: '',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        // Popular Searches (when focused and empty)
        if (widget.isSearchFocused && _controller.text.isEmpty)
          _PopularSearchTags(
            popularSearches: popularSearches,
            onSearchSelected: (query) {
              _controller.text = query;
              widget.onChanged(query);
              _navigateToSearchResults(query);
            },
          ),
        // Suggestions (when typing)
        if (widget.isSearchFocused &&
            _controller.text.isNotEmpty &&
            widget.suggestions.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.suggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    _controller.text = suggestion;
                    widget.onChanged(suggestion);
                    _navigateToSearchResults(suggestion);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// Private widget only used by CustomSearchBar
class _PopularSearchTags extends StatelessWidget {
  final Map<String, List<String>> popularSearches;
  final Function(String) onSearchSelected;

  const _PopularSearchTags({
    required this.popularSearches,
    required this.onSearchSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Popular Searches',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ...popularSearches.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search item
                InkWell(
                  onTap: () => onSearchSelected(entry.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tags
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Wrap(
                    spacing: 4.0,
                    children: entry.value.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.grey[100],
                        labelStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1, thickness: 0.5),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
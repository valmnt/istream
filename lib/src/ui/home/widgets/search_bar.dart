import 'package:flutter/material.dart';
import 'package:istream/src/shared/colors.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          cursorColor: primary,
          onChanged: onChanged,
          autofocus: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.8),
            ),
            hintText: "Search in a snap! 🚀",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

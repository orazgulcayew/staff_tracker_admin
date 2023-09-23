import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;
  const SearchInput({required this.onChanged, required this.hintText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.green,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey[200] ?? Colors.white, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green[100] ?? Colors.white, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}

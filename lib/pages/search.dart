import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 430,
            height: 90,
            child: CupertinoSearchTextField(),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Recent Walks", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LogsView extends StatefulWidget {
  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text("Shake Phone to open Console."),
          ),
        ),
      ),
    );
  }
}

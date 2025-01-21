import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ExamAI());

class ExamAI extends StatelessWidget {
  const ExamAI({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ExamAI", home: ExamAIApp());
  }
}

class ExamAIApp extends StatefulWidget {
  const ExamAIApp({super.key});
  @override
  State<ExamAIApp> createState() => _ExamAIApp();
}

class _ExamAIApp extends State<ExamAIApp> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  late TextEditingController _controller;
  final TextEditingController _apiController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _openDrawer() {
  //   _scaffoldKey.currentState!.openDrawer();
  // }

  // void _closeDrawer() {
  //   Navigator.of(context).pop();
  // }

  Future<void> _sendAPI() async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/sendKey"),
        body: {'key': _apiController.text},
      );
      if (response.statusCode == 200) {
        log("Key sent successfully!");
      } else {
        log("Failed to send key. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Useless fuck! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "ExamAI",
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Groq API Key"),
                Divider(color: Colors.grey),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                  child: TextField(
                    controller: _apiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Groq API Key",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Text("Add TextBook:"),
                Divider(color: Colors.grey),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Upload"),
                          Icon(Icons.upload),
                        ]),
                  ),
                ),
              ]),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  onSubmitted: null,
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendAPI,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(const ExamAI());
}

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
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _apiController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _statusMessage = '';

//Sends API Code to the backend
  void _sendAPI(String? value) async {
    setState(() {
      _statusMessage = 'Sending...';
    });
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/"),
        body: {'key': value},
      );
      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "Key sent successfully!";
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to send key! Please retry after sometime';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error! Cannot connect to the server';
      });
    }
  }

//Sends query to the backend when user hits enter (Planning to remove soon)
  void _sendQuery(String? value) async {
    setState(() {
      _controller.clear();
    });
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/send_prompt"),
        body: {'query': value},
      );

      if (response.statusCode == 200) {
        log("We won bro");
      } else {
        log("We lost bro");
      }
    } catch (e) {
      log("We are done! $e");
    }
  }

//Sends query to the backend when user clicks on submit button
  void _sendPrompt() async {
    final query = _controller.text;
    setState(() {
      _controller.clear();
    });
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/send_prompt"),
        body: {'query': query},
      );

      if (response.statusCode == 200) {
        log("We won bro");
      } else {
        log("We lost bro");
      }
    } catch (e) {
      log("We are done! $e");
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
        scrolledUnderElevation: scrolledUnderElevation,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Text('Hi! How could I help you today?'),
            ),
          ],
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
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _apiController,
                        onSubmitted: _sendAPI,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Groq API Key",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Text(_statusMessage),
                    ],
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
                  onSubmitted: _sendQuery,
                  controller: _controller,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendPrompt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File pdfFile = File(result.files.single.path!);
      final uri = Uri.parse("http://127.0.0.1:5000/upload");
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('pdf', pdfFile.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        log('PDF uploaded successfully');
      } else {
        log('Failed to upload pdf');
      }
    } else {
      log("No file selected!");
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
                    onPressed: _selectFiles,
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
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

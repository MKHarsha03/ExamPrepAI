import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileMessage = '';

  final List<String> chats = [];

//Sends query to the backend when user clicks on submit button
  void _sendPrompt() async {
    final query = _controller.text;
    setState(() {
      chats.add(query);
      _controller.clear();
    });
    try {
      final response = await http.post(
        Uri.parse("SERVER_URL/send_prompt"),
        body: {'query': query},
      );

      if (response.statusCode == 200) {
        log("We won bro");
        final reply = jsonDecode(response.body);
        setState(() {
          chats.add(reply['bot_response']);
        });
      } else {
        log("We lost bro");
      }
    } catch (e) {
      log("We are done! $e");
    }
  }

  void sendDocs() async {
    setState(() {
      _fileMessage = "Sending PDF";
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      final uri = Uri.parse('SERVER_URL/send_docs');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final reply = jsonDecode(responseData.body);
        setState(() {
          _fileMessage = reply['message'].toString();
        });
      } else {
        log("File not sent!");
      }
      log("File was selected!");
    } else {
      log("User didn't pick");
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
      drawer: Drawer(
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Add TextBook:"),
                Divider(color: Colors.grey),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                  child: ElevatedButton(
                    onPressed: sendDocs,
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
                Text(_fileMessage),
                Text("Add PPT(PDF Format) or Images:"),
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
                          Text("Use OCR"),
                          Icon(Icons.visibility),
                        ]),
                  ),
                ),
                Text(_fileMessage),
              ]),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  chats[index],
                ));
              },
            ),
          ),
          const Divider(height: 1.0),
          Center(
              child: Row(
            children: [
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Ask anything...",
                  ),
                ),
              ),
              IconButton(
                onPressed: _sendPrompt,
                icon: const Icon(Icons.send),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

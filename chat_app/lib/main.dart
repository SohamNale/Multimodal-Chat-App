import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _shouldScrollToNewMessage = false;  // Flag to scroll after response is received

  final String apiUrl = '{use your ngrok link}/generate';

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isLoading = true;
      _shouldScrollToNewMessage = true;  // Mark that we need to scroll after response
    });

    _controller.clear();

    // Scroll down before the response is displayed to ensure the new input is visible
    _scrollToNewMessage();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 200) {
        final botMessage = jsonDecode(response.body)['response'];
        setState(() {
          _messages.add({"role": "bot", "content": botMessage});
        });
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "bot", "content": "Error: Unable to fetch response."});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      // After response is received, scroll to the new message location
      if (_shouldScrollToNewMessage) {
        _scrollToNewMessage();
      }
    }
  }

  // Function to scroll to the new message
  void _scrollToNewMessage() {
    if (_scrollController.hasClients) {
      // Scroll to the bottom to make sure the new message is visible
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Listen for scroll position to detect if the user is at the bottom
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
// User is at the bottom
      });
    } else {
      setState(() {
// User is not at the bottom
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);  // Add scroll listener
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);  // Remove listener when disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: const Text(
          'Chat AI',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
            fontSize: 30, // Optional: Adjust the font size
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,  // Set the controller here
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








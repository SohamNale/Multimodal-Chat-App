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
      title: 'Multimodal Chat App',
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
  bool _shouldScrollToNewMessage = false;

  final String apiUrl = 'https://115c-34-125-150-100.ngrok-free.app/generate';

  // Dropdown menu variables
  String _selectedModel = 'llama'; // Default model
  final List<String> _models = ['llama', 'gemini', 'mistral'];

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isLoading = true;
      _shouldScrollToNewMessage = true;
    });

    _controller.clear();

    _scrollToNewMessage();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"message": userMessage, "model": _selectedModel}),
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

      if (_shouldScrollToNewMessage) {
        _scrollToNewMessage();
      }
    }
  }

  void _scrollToNewMessage() {
    if (_scrollController.hasClients) {
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
        toolbarHeight: 100, // Increase AppBar height for proper spacing
        title: Padding(
          padding: const EdgeInsets.only(top: 20), // Adjust this value to balance the positioning
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Ensure alignment to the center
            children: [
              const Text(
                'Multimodal Chat AI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Adjust font size as needed
                ),
              ),
              DropdownButton<String>(
                value: _selectedModel,
                items: _models.map((String model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(
                      model.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Adjust font size as needed
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModel = newValue!;
                  });
                },
                underline: Container(),
              ),
            ],
          ),
        ),
        centerTitle: true, // Ensure the column remains centered horizontally
        backgroundColor: const Color(0xFFE6E6FA), // Custom cream color (or use any other color you prefer)
      ),
      //backgroundColor: const Color(0xFFFFFAFA), // Light cream or off-white for the body
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
                      color: isUser ? Colors.blue : const Color(0xFFE0B0FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black,
                      fontSize: isUser ? 16.0 : 16.0),
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
                      filled: true, // Enables background fill
                      fillColor: Colors.white, // White background
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import '../models/phone_model.dart';
import '../widgets/phone_bento_card.dart';
import '../widgets/phone_detail_sheet.dart';

class ChatScreen extends StatefulWidget {
  final String initialQuery;

  const ChatScreen({super.key, this.initialQuery = ''});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _messages.add({
      'sender': 'bot',
      'text': "Hello! How can I assist you in finding a smartphone today?",
    });

    if (widget.initialQuery.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _sendMessage(widget.initialQuery);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });

    _controller.clear(); // Clear input immediately
    _scrollToBottom();

    try {
      final response = await fetchSmartphoneRecommendation(text);
      setState(() {
        _isLoading = false;
        if (response != null) {
          _messages.add({
            'sender': 'bot', 
            'text': _cleanResponse(response['response']),
            'phones': (response['phones'] as List)
                .map((phoneJson) => PhoneModel.fromJson(phoneJson))
                .toList(),
          });
        } else {
          _messages.add({
            'sender': 'bot',
            'text': "Sorry, I couldn't find any matches. Try again?",
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'sender': 'bot',
          'text': "Something went wrong. Please try again.",
        });
      });
    } finally {
      _scrollToBottom();
    }
  }

  String _cleanResponse(String text) {
    // Remove IDs like (ID: abc123)
    String cleaned = text.replaceAll(RegExp(r'\(ID: \w+\)'), "");
    // Remove markdown bold/italic markers
    cleaned = cleaned.replaceAllMapped(RegExp(r'(\*\*|\*)(.*?)\1'), 
      (match) => match.group(2) ?? "");
    return cleaned;
  }

  Future<Map<String, dynamic>?> fetchSmartphoneRecommendation(String query) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:4000/api/query'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Phone Advisor"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';

                return Column(
                  children: [
                    // Message Bubble
                    Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF9575CD) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    // Phone Recommendations (if any)
                    if (message['phones'] != null && 
                        (message['phones'] as List<PhoneModel>).isNotEmpty)
                      _buildPhoneRow(message['phones']),
                  ],
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SpinKitFadingCircle(
                color: const Color(0xFF9575CD),
                size: 20,
              ),
            ),
          // Input Field
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: theme.colorScheme.surface.withOpacity(0.9),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask about phones...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF9575CD),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(List<PhoneModel> phones) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: phones.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: 8,
              top: 8,
            ),
            child: SizedBox(
              width: 140,
              child: PhoneBentoCard(
                phone: phones[index],
                onTap: () => _showPhoneDetails(phones[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPhoneDetails(PhoneModel phone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PhoneDetailSheet(phone: phone),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
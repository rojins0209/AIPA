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
  List<PhoneModel> _recommendedPhones = [];
  bool _showPhoneGrid = false;

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
      _showPhoneGrid = false;
    });

    _scrollToBottom();

    try {
      final response = await fetchSmartphoneRecommendation(text);
      setState(() {
        _isLoading = false;
        if (response != null) {
          _messages.add({'sender': 'bot', 'text': response['response']});
          _recommendedPhones = (response['phones'] as List)
              .map((phoneJson) => PhoneModel.fromJson(phoneJson))
              .toList();
          _showPhoneGrid = _recommendedPhones.isNotEmpty;
        } else {
          _messages.add({
            'sender': 'bot',
            'text': "Sorry, I couldn’t find any matches. Try again?",
          });
          _recommendedPhones = [];
          _showPhoneGrid = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'sender': 'bot',
          'text': "Something went wrong. Please try again.",
        });
        _recommendedPhones = [];
        _showPhoneGrid = false;
      });
    } finally {
      _scrollToBottom();
      _controller.clear();
    }
  }

  Future<Map<String, dynamic>?> fetchSmartphoneRecommendation(String query) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.42.120:4000/api/query'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
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
        titleTextStyle: TextStyle(
          color: theme.textTheme.titleLarge?.color,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      body: Container(
        color: theme.colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: _showPhoneGrid ? _buildPhoneGrid() : _buildChatList(),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SpinKitFadingCircle(
                  color: const Color(0xFF9575CD), // Soft purple
                  size: 20,
                ),
              ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: theme.colorScheme.surface.withOpacity(0.9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask about a phone...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              style: const TextStyle(fontSize: 16),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF9575CD), // Soft purple
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    final theme = Theme.of(context);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isUser = message['sender'] == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF9575CD) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneGrid() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            "Recommended Phones (${_recommendedPhones.length})",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.titleLarge?.color?.withOpacity(0.9),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: _recommendedPhones.length,
            itemBuilder: (context, index) {
              return PhoneBentoCard(
                phone: _recommendedPhones[index],
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => PhoneDetailSheet(phone: _recommendedPhones[index]),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
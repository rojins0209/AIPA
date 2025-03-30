import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import '../models/phone_model.dart';
import '../widgets/phone_detail_sheet.dart'; // Assuming this exists

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
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
      'text':
          "Hi there! I'm your smartphone assistant. How can I help you find your perfect phone today?",
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _controller.dispose(); // Dispose the controller
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
    if (text.trim().isEmpty) return; // Don't send empty messages.

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
            'text':
                "Sorry, I couldn't find any recommendations. Please try a different query.",
          });
          _recommendedPhones = []; // Clear any previous results
          _showPhoneGrid =
              false; // Ensure grid is not shown on error/no results
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'sender': 'bot',
          'text': "An error occurred. Please check your connection and try again.",
        });
        _recommendedPhones = [];
        _showPhoneGrid = false;
      });
      print("Error: $e"); // Important: Log the error.
    } finally {
      _scrollToBottom();
      _controller.clear();
    }
  }

  Future<Map<String, dynamic>?> fetchSmartphoneRecommendation(
      String query) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.201.81.252:4000/api/query'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        // print("Response: ${response.body}"); //  for debugging
        return jsonDecode(response.body);
      } else {
        print(
            "Failed to fetch data: ${response.statusCode}"); // Log non-200
        return null; // Explicitly return null for non-200 responses
      }
    } catch (e) {
      print("Error: $e");
      return null; // Return null on exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smartphone Finder"),
        elevation: 4, // Add elevation for a Material look
      ),
      body: Column(
        children: [
          Expanded(
            child: _showPhoneGrid ? _buildPhoneGrid() : _buildChatList(),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SpinKitThreeBounce(
                color: Theme.of(context).colorScheme.primary,
                size: 25,
              ),
            ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ask about a smartphone...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder( // Use an outline border
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
              ),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            // Use FloatingActionButton for Material Design
            onPressed: () => _sendMessage(_controller.text),
            shape: const CircleBorder(),
            child: const Icon(Icons.send), // Make it a circle
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isUser = message['sender'] == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300], // Use a grey shade for bot messages
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: !isUser
                        ? Radius.zero
                        : const Radius.circular(20),
                    bottomRight: isUser
                        ? Radius.zero
                        : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color
                      blurRadius: 4, // Spread of the shadow
                      offset: Offset(0, 2), // Offset of the shadow
                    ),
                  ],
                ),
                child: Text(
                  message['text'],
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87, // Darker text for bot
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneGrid() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Recommended Phones (${_recommendedPhones.length})",
            style: Theme.of(context).textTheme.titleLarge, // Use titleLarge
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _recommendedPhones.length,
            itemBuilder: (context, index) {
              return PhoneBentoCard(  // Use the modified PhoneBentoCard
                phone: _recommendedPhones[index],
                onTap: () {
                  // Show details when a card is tapped.
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Make it full-screen if needed
                    builder: (context) =>
                        PhoneDetailSheet(phone: _recommendedPhones[index]),
                    shape: const RoundedRectangleBorder(  //Style the bottomSheet
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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

// Modified PhoneBentoCard Widget (Assuming it's in phone_bento_card.dart)
class PhoneBentoCard extends StatelessWidget {
  final PhoneModel phone;
  final VoidCallback? onTap; // Add this line

  const PhoneBentoCard({super.key, required this.phone, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap with GestureDetector
      onTap: onTap,  // Use the onTap callback
      child: Card( // Use Card for Material Design
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    phone.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Handle errors, e.g., show a placeholder
                      return const Center(child: Text("Image"));
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                phone.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(221, 255, 255, 255),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Text(
                phone.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600], // Use a dark grey
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


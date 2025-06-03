import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportChatScreen extends StatefulWidget {
  final bool isAdminView;
  final String? customerName;

  const SupportChatScreen({
    super.key,
    this.isAdminView = false,
    this.customerName = 'John Doe',
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'customer', 'text': 'Hello, I need help with my order', 'time': '10:30 AM'},
    {'sender': 'support', 'text': 'How can I assist you today?', 'time': '10:32 AM'},
    {'sender': 'customer', 'text': "My package hasn't arrived", 'time': '10:33 AM'},
    {'sender': 'customer', 'text': 'Order #12345', 'time': '10:34 AM'},
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: Text(
          widget.isAdminView ? 'Support Chat' : 'Live Chat Support',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E5D32),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: const Color(0xFF2E5D32),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (widget.isAdminView) _buildCustomerHeader(context),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildCustomerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2E5D32).withOpacity(0.1),
            child: const Icon(Icons.person, color: Color(0xFF2E5D32)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.customerName ?? 'Customer',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF2E5D32),
                ),
              ),
              Text(
                'Active now',
                style: GoogleFonts.lato(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isCustomer = message['sender'] == 'customer';
    final showOnLeft = (widget.isAdminView && isCustomer) || (!widget.isAdminView && !isCustomer);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: showOnLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: showOnLeft ? Colors.white : const Color(0xFF2E5D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'],
                  style: GoogleFonts.lato(color: const Color(0xFF2E5D32)),
                ),
                const SizedBox(height: 4),
                Text(
                  message['time'],
                  style: GoogleFonts.lato(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF2E5D32),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  setState(() {
                    _messages.add({
                      'sender': widget.isAdminView ? 'support' : 'customer',
                      'text': _messageController.text,
                      'time': 'Now',
                    });
                    _messageController.clear();
                    _scrollToBottom();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
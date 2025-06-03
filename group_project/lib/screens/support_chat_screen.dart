import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_navigation.dart';

class SupportChatScreen extends StatefulWidget {
  final bool isAdminView;
  final String? customerName;

  const SupportChatScreen({
    super.key,
    this.isAdminView = false,
    this.customerName = 'Customer',
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
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFFDFDFD),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: _buildMinimalLogo(context),
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E5D32)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildHeaderSection(context),
                  if (widget.isAdminView) _buildCustomerHeader(context),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E5D32).withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMessageInput(context),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildMinimalLogo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFB6D433),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'source',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32),
            letterSpacing: 2,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 1,
          height: 16,
          color: const Color(0xFF2E5D32).withOpacity(0.3),
        ),
        Text(
          'zero',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E5D32),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'your',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'support chat',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF2E5D32),
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFB6D433).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(FontAwesomeIcons.user, color: Color(0xFF2E5D32), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.customerName ?? 'Customer',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xFF2E5D32),
                ),
              ),
              Text(
                'Active now',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFB6D433),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: showOnLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: showOnLeft ? const Color(0xFFF8F9FA) : const Color(0xFFB6D433).withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: showOnLeft ? const Radius.circular(0) : const Radius.circular(16),
                bottomRight: showOnLeft ? const Radius.circular(16) : const Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'],
                  style: GoogleFonts.poppins(color: const Color(0xFF2E5D32)),
                ),
                const SizedBox(height: 4),
                Text(
                  message['time'],
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2E5D32).withOpacity(0.6),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF2E5D32).withOpacity(0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: GoogleFonts.poppins(color: const Color(0xFF2E5D32)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFB6D433),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';
import 'support_chat_screen.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Customer Service',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildContactOptions(context),
            const SizedBox(height: 30),
            _buildFAQSection(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How can we help you?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactOption(
            context,
            Icons.chat_bubble_outline,
            'Live Chat',
            'Chat with our support team in real-time',
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SupportChatScreen(isAdminView: false),
              ),
            ),
          ),
          const Divider(height: 30),
          _buildContactOption(
            context,
            Icons.email_outlined,
            'Email Us',
            'Get a response within 24 hours',
                () => _showComingSoon(context),
          ),
          const Divider(height: 30),
          _buildContactOption(
            context,
            Icons.phone_outlined,
            'Call Us',
            'Mon-Fri, 9am-5pm',
                () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          _buildFAQItem(
            context,
            'How do I track my order?',
            'You can track your order from the Orders section in your account.',
          ),
          const Divider(height: 20),
          _buildFAQItem(
            context,
            'What is your return policy?',
            'We accept returns within 30 days of purchase for unused products.',
          ),
          const Divider(height: 20),
          _buildFAQItem(
            context,
            'Do you offer international shipping?',
            'Currently, we only ship within the United States.',
          ),
          const Divider(height: 20),
          _buildFAQItem(
            context,
            'How can I change my delivery address?',
            'You can update your delivery address in the Settings section.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            answer,
            style: GoogleFonts.lato(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Coming Soon',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Text(
          'This feature will be available in the next update.',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.lato(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
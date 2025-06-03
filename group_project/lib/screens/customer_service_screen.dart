import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_navigation.dart';
import 'support_chat_screen.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildContactOptions(context),
                const SizedBox(height: 30),
                _buildFAQSection(context),
                const SizedBox(height: 30),
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
          'customer support',
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

  Widget _buildContactOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        Text(
        'How can we help you?',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E5D32),
        ),
      ),
      const SizedBox(height: 20),
      _buildContactOption(
        context,
        FontAwesomeIcons.commentDots,
        'Live Chat',
        'Chat with our support team in real-time',
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SupportChatScreen(isAdminView: false),
          ),
        ),
      ),
          const Divider(
            height: 30,
            color: Color(0xFF2E5D32),
          ),
          _buildContactOption(
            context,
            FontAwesomeIcons.envelope,
            'Email Us',
            'Get a response within 24 hours',
                () => _showComingSoon(context),
          ),

          const Divider(height: 30, color: Color(0xFF2E5D32)),
        _buildContactOption(
          context,
          FontAwesomeIcons.phone,
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
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFB6D433).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2E5D32),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E5D32),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF2E5D32).withOpacity(0.6),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E5D32),
            ),
          ),
          const SizedBox(height: 15),
          _buildFAQItem(
            context,
            'How do I track my order?',
            'You can track your order from the Orders section in your account.',
          ),
          const Divider(height: 20, color: Color(0xFF2E5D32)),
          _buildFAQItem(
            context,
            'What is your return policy?',
            'We accept returns within 30 days of purchase for unused products.',
          ),
          const Divider(height: 20, color: Color(0xFF2E5D32)),
          _buildFAQItem(
            context,
            'Do you offer international shipping?',
            'Currently, we only ship within the United States.',
          ),
          const Divider(height: 20, color: Color(0xFF2E5D32)),
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
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E5D32),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF2E5D32).withOpacity(0.8),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Coming Soon',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
          ),
        ),
        content: Text(
          'This feature will be available in the next update.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFF2E5D32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
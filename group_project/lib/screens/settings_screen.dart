import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';
import 'notification_manager_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileSection(context),
            const SizedBox(height: 20),
            _buildSettingsOptions(context),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/profile.jpg'),
                fit: BoxFit.cover,
              ),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          _buildSettingsOption(
            context,
            Icons.notifications_active_outlined,
            'Notifications Manager',
            Icons.chevron_right,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationManagerScreen(),
                ),
              );
            },
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            Icons.location_on_outlined,
            'Delivery Address',
            Icons.chevron_right,
                () {
              Navigator.pushNamed(context, Routes.deliveryAddress);
            },
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            Icons.payment_outlined,
            'Payment Methods',
            Icons.chevron_right,
                () {},
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            Icons.security_outlined,
            'Privacy & Security',
            Icons.chevron_right,
                () {},
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            Icons.help_outline,
            'Help & Support',
            Icons.chevron_right,
                () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context,
      IconData icon,
      String title,
      IconData trailingIcon,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
      ),
      trailing: Icon(
        trailingIcon,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: Colors.red.withOpacity(0.2)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.welcome);
      },
      child: Text(
        'Log Out',
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
    );
  }
}

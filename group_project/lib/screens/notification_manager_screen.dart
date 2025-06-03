import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';

class NotificationManagerScreen extends StatefulWidget {
  const NotificationManagerScreen({super.key});

  @override
  State<NotificationManagerScreen> createState() => _NotificationManagerScreenState();
}

class _NotificationManagerScreenState extends State<NotificationManagerScreen> {
  bool notificationsEnabled = true;
  int _secondsToSchedule = 10;
  String _lastNotificationStatus = 'No notifications sent yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                  _buildNotificationToggle(),
                  const SizedBox(height: 30),
                  _buildNotificationDemoSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.bell, size: 20, color: Color(0xFFB6D433)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Enable Notifications',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2E5D32),
              ),
            ),
          ),
          Switch(
            value: notificationsEnabled,
            activeColor: const Color(0xFFB6D433),
            onChanged: (value) => setState(() {
              notificationsEnabled = value;
              _updateStatus(value ? "Notifications enabled" : "Notifications disabled");
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Test Notifications',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
          ),
        ),
        const SizedBox(height: 16),
        _buildDemoButton(
          "Test Immediate Notification",
          FontAwesomeIcons.bolt,
          _testImmediateNotification,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                "Schedule Notification",
                FontAwesomeIcons.clock,
                _testScheduledNotification,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: () => _adjustScheduleTime(-5),
            ),
            Text(
              '$_secondsToSchedule s',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF2E5D32),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => _adjustScheduleTime(5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          "Cancel All Notifications",
          FontAwesomeIcons.times,
          _cancelAllNotifications,
          isDestructive: true,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E5D32).withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _lastNotificationStatus,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF2E5D32).withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoButton(
      String text,
      IconData icon,
      VoidCallback onPressed, {
        bool isDestructive = false,
      }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDestructive ? Colors.white : const Color(0xFFF5F9F0),
        foregroundColor: isDestructive ? Colors.red : const Color(0xFF2E5D32),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDestructive ? Colors.red.withOpacity(0.3) : const Color(0xFFB6D433).withOpacity(0.3),
          ),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(String message) {
    setState(() {
      _lastNotificationStatus = "$message\n${DateTime.now().toLocal()}";
    });
  }

  Future<void> _testImmediateNotification() async {
    if (!notificationsEnabled) return;

    try {
      // await NotificationService.showNotification(
      //   id: 1,
      //   title: 'Immediate Notification',
      //   body: 'This appeared immediately!',
      // );
      _updateStatus("Immediate notification sent!");
    } catch (e) {
      _updateStatus("Error: $e");
    }
  }

  Future<void> _testScheduledNotification() async {
    if (!notificationsEnabled) return;

    try {
      // await NotificationService.scheduleNotification(
      //   id: 2,
      //   title: 'Scheduled Notification',
      //   body: 'Scheduled $_secondsToSchedule seconds ago',
      //   duration: Duration(seconds: _secondsToSchedule),
      // );
      _updateStatus("Scheduled for $_secondsToSchedule seconds");
    } catch (e) {
      _updateStatus("Error: $e");
    }
  }

  Future<void> _cancelAllNotifications() async {
    try {
      // await NotificationService.cancelAllNotifications();
      _updateStatus("All notifications cancelled");
    } catch (e) {
      _updateStatus("Error: $e");
    }
  }

  void _adjustScheduleTime(int change) {
    setState(() {
      _secondsToSchedule = (_secondsToSchedule + change).clamp(5, 60);
    });
  }
}
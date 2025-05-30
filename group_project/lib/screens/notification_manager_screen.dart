import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notifications/flutter_local_notifications.dart';

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
      appBar: AppBar(
        title: Text('Notification Manager', style: GoogleFonts.playfairDisplay()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNotificationControlPanel(context),
            const SizedBox(height: 20),
            _buildNotificationDemoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationControlPanel(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) => setState(() {
                notificationsEnabled = value;
                _updateStatus(value ? "Notifications enabled" : "Notifications disabled");
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationDemoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Notification Demo", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDemoButton(
              "Test Immediate Notification",
              Icons.notifications,
              _testImmediateNotification,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDemoButton(
                    "Schedule Notification",
                    Icons.timer,
                    _testScheduledNotification,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _adjustScheduleTime(-5),
                ),
                Text("$_secondsToSchedule s"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _adjustScheduleTime(5),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDemoButton(
              "Cancel All Notifications",
              Icons.notifications_off,
              _cancelAllNotifications,
              isDestructive: true,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_lastNotificationStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButton(
      String text,
      IconData icon,
      VoidCallback onPressed, {
        bool isDestructive = false,
      }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: isDestructive ? Colors.red : Theme.of(context).primaryColor,
        backgroundColor: isDestructive ? Colors.red[50] : Colors.white,
      ),
      onPressed: onPressed,
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
      await NotificationService.showNotification(
        id: 1,
        title: 'Immediate Notification',
        body: 'This appeared immediately!',
      );
      _updateStatus("Immediate notification sent!");
    } catch (e) {
      _updateStatus("Error: $e");
    }
  }

  Future<void> _testScheduledNotification() async {
    if (!notificationsEnabled) return;

    try {
      await NotificationService.scheduleNotification(
        id: 2,
        title: 'Scheduled Notification',
        body: 'Scheduled $_secondsToSchedule seconds ago',
        duration: Duration(seconds: _secondsToSchedule),
      );
      _updateStatus("Scheduled for $_secondsToSchedule seconds");
    } catch (e) {
      _updateStatus("Error: $e");
    }
  }

  Future<void> _cancelAllNotifications() async {
    try {
      await NotificationService.cancelAllNotifications();
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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../routes.dart';

class SourceZeroBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const SourceZeroBottomNavigationBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
        break;
      case 1:
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.orders, (route) => false);
        break;
      case 2:
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.products, (route) => false);
        break;
      case 3:
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.settings, (route) => false);
        break;
      case 4:
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.adminDashboard, (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E5D32),
        unselectedItemColor: const Color(0xFF2E5D32).withOpacity(0.4),
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.store),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userShield), // changed from gaugeHigh
            label: 'Admin',
          ),

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes.dart';
import '../support_chat_screen.dart';
import 'product_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildWelcomeSection(context),
                  const SizedBox(height: 30),
                  _buildStatsRow(context),
                  const SizedBox(height: 30),
                  _buildQuickActionsTitle(context),
                  const SizedBox(height: 15),
                  _buildQuickActions(context),
                  const SizedBox(height: 30),
                  _buildRecentOrdersTitle(context),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildRecentOrders(context),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to support chat
        },
        backgroundColor: const Color(0xFF2E5D32),
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2E5D32)),
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.home);
        },
      ),


      backgroundColor: const Color(0xFFFDFDFD),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _buildAdminLogo(context),
        titlePadding: const EdgeInsets.only(bottom: 16),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E5D32).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: const Color(0xFF2E5D32),
            iconSize: 22,
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E5D32).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.logout_outlined),
            color: const Color(0xFF2E5D32),
            iconSize: 22,
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminLogo(BuildContext context) {
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
          'admin',
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

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dashboard',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'welcome back',
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

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Orders',
            '247',
            FontAwesomeIcons.shoppingBag,
            const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            context,
            'Pending',
            '12',
            FontAwesomeIcons.clock,
            const Color(0xFFFF9800),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            context,
            'Revenue',
            '\$5,247',
            FontAwesomeIcons.dollarSign,
            const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF2E5D32).withOpacity(0.7),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E5D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsTitle(BuildContext context) {
    return Text(
      'quick actions',
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF2E5D32),
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildActionCard(context, 'Add Product', Icons.add_circle_outline, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductManagementScreen()),
          );
        }),
        _buildActionCard(context, 'Manage Inventory', Icons.inventory_outlined, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductManagementScreen()),
          );
        }),
        _buildActionCard(context, 'View Reports', Icons.analytics_outlined, () {}),
        _buildActionCard(context, 'User Management', Icons.people_outline, () {}),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF2E5D32),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E5D32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'recent orders',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2E5D32),
            letterSpacing: 1,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Text(
            'view all',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF2E5D32).withOpacity(0.6),
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOrderItem(context, '#12345', 'Completed', '\$45.99'),
          Divider(height: 1, color: const Color(0xFF2E5D32).withOpacity(0.1)),
          _buildOrderItem(context, '#12346', 'Processing', '\$32.50'),
          Divider(height: 1, color: const Color(0xFF2E5D32).withOpacity(0.1)),
          _buildOrderItem(context, '#12347', 'Pending', '\$67.25'),
          Divider(height: 1, color: const Color(0xFF2E5D32).withOpacity(0.1)),
          _buildOrderItem(context, '#12348', 'Cancelled', '\$24.99'),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, String orderId, String status, String amount) {
    Color statusColor = _getStatusColor(status);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      title: Text(
        orderId,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E5D32),
        ),
      ),
      subtitle: Text(
        'Yesterday, 3:45 PM',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w300,
          color: const Color(0xFF2E5D32).withOpacity(0.6),
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E5D32),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFFFF9800);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFF2196F3);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF2E5D32);
    }
  }
}
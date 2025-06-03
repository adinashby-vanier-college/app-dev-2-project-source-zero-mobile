import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  const SizedBox(height: 10),
                  _buildHeaderSection(context),
                  const SizedBox(height: 35),
                  _buildTabBar(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTabBarView(context),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
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
      ],
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
          'order history',
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

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFB6D433),
        ),
        indicatorSize: TabBarIndicatorSize.label, // ✅ This ensures the indicator covers the label container
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ✅ Widen the label area

        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF2E5D32).withOpacity(0.5),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        tabs: const [
          Tab(text: 'active'),
          Tab(text: 'completed'),
          Tab(text: 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(context, 'active'),
          _buildOrderList(context, 'completed'),
          _buildOrderList(context, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String type) {
    final orders = _getOrdersForType(type);

    if (orders.isEmpty) {
      return _buildEmptyState(context, type);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(context, orders[index], type),
    );
  }

  Widget _buildEmptyState(BuildContext context, String type) {
    IconData icon;
    String title;
    String subtitle;

    switch (type) {
      case 'active':
        icon = FontAwesomeIcons.clock;
        title = 'no active orders';
        subtitle = 'your current orders will appear here';
        break;
      case 'completed':
        icon = FontAwesomeIcons.checkCircle;
        title = 'no completed orders';
        subtitle = 'your delivered orders will appear here';
        break;
      case 'cancelled':
        icon = FontAwesomeIcons.timesCircle;
        title = 'no cancelled orders';
        subtitle = 'cancelled orders will appear here';
        break;
      default:
        icon = FontAwesomeIcons.box;
        title = 'no orders';
        subtitle = 'your orders will appear here';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFB6D433).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2E5D32).withOpacity(0.4),
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2E5D32),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF2E5D32).withOpacity(0.6),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'order #${order['id']}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF2E5D32),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order['date'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF2E5D32).withOpacity(0.6),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['status'],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(order['status']),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF2E5D32).withOpacity(0.06),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF8F9FA),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          order['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFB6D433).withOpacity(0.1),
                              child: const Icon(
                                FontAwesomeIcons.image,
                                color: Color(0xFF2E5D32),
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order['itemCount']} items',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2E5D32),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order['items'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF2E5D32).withOpacity(0.7),
                              letterSpacing: 0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order['total'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2E5D32),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (type == 'active') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2E5D32).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'track order',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2E5D32),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E5D32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (type == 'completed') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFB6D433),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'reorder',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getOrdersForType(String type) {
    switch (type) {
      case 'active':
        return [
          {
            'id': '12345',
            'date': 'june 12, 2024',
            'total': '\$24.99',
            'status': 'processing',
            'itemCount': 3,
            'items': 'organic treats, cold pressed oil, wellness bundle',
            'image': 'assets/treats.png',
          },
          {
            'id': '12344',
            'date': 'june 10, 2024',
            'total': '\$18.50',
            'status': 'shipped',
            'itemCount': 2,
            'items': 'nut milk, organic treats',
            'image': 'assets/macademia.jpg',
          },
        ];
      case 'completed':
        return [
          {
            'id': '12343',
            'date': 'june 5, 2024',
            'total': '\$32.75',
            'status': 'delivered',
            'itemCount': 4,
            'items': 'wellness bundle, cold pressed oil, organic treats, nut milk',
            'image': 'assets/blueprint.png',
          },
          {
            'id': '12342',
            'date': 'may 28, 2024',
            'total': '\$15.20',
            'status': 'delivered',
            'itemCount': 2,
            'items': 'organic treats, cold pressed oil',
            'image': 'assets/oliveoil.png',
          },
        ];
      case 'cancelled':
        return [];
      default:
        return [];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFFFF9800);
      case 'shipped':
        return const Color(0xFF2196F3);
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF2E5D32);
    }
  }
}
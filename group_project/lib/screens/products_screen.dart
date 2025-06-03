import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
                  _buildWelcomeSection(context),
                  const SizedBox(height: 35),
                  _buildSearchBar(context),
                  const SizedBox(height: 40),
                  _buildCategoriesSection(context),
                  const SizedBox(height: 45),
                  _buildProductsGrid(context),
                ],
              ),
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

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'our collection',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'organic selection',
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

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5D32).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: 'search organic products',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.4),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(14),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF2E5D32),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {'name': 'all', 'icon': FontAwesomeIcons.layerGroup},
      {'name': 'food', 'icon': FontAwesomeIcons.leaf},
      {'name': 'drinks', 'icon': FontAwesomeIcons.glassWater},
      {'name': 'wellness', 'icon': FontAwesomeIcons.spa},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'categories',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2E5D32),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((category) =>
              _buildMinimalCategoryCard(context, category['name'] as String, category['icon'] as IconData)
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildMinimalCategoryCard(BuildContext context, String title, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle category selection
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 80,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFFB6D433),
                size: 20,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2E5D32),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    final products = [
      {'name': 'organic treats', 'price': '5.99', 'image': 'assets/treats.png'},
      {'name': 'cold pressed oil', 'price': '12.99', 'image': 'assets/oliveoil.png'},
      {'name': 'wellness bundle', 'price': '29.99', 'image': 'assets/blueprint.png'},
      {'name': 'nut milk', 'price': '12.99', 'image': 'assets/macademia.jpg'},
      {'name': 'allulose', 'price': '11.99', 'image': 'assets/allulose.webp'},
      {'name': 'almond butter', 'price': '9.49', 'image': 'assets/almondbutter.webp'},
      {'name': 'coconut sugar', 'price': '7.99', 'image': 'assets/coconut_sugar.jpg'},
      {'name': 'chia seeds', 'price': '8.49', 'image': 'assets/chia_seeds.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'all products',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2E5D32),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: products.map((product) =>
              _buildProductCard(
                  context,
                  product['name'] as String,
                  product['price'] as String,
                  product['image'] as String
              )
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.productDetail);
      },
      child: Container(
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
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: const Color(0xFFF8F9FA),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFB6D433).withOpacity(0.1),
                        child: const Icon(
                          FontAwesomeIcons.image,
                          color: Color(0xFF2E5D32),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2E5D32),
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$$price',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2E5D32),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB6D433),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
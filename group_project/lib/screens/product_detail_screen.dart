import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/allulose.webp',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFB6D433).withOpacity(0.1),
                  );
                },
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 16, top: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: const Color(0xFF2E5D32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined),
                  color: const Color(0xFF2E5D32),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(context),
                  const SizedBox(height: 20),
                  _buildPriceSection(context),
                  const SizedBox(height: 25),
                  _buildDescriptionSection(context),
                  const SizedBox(height: 25),
                  _buildNutritionSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 1),
      bottomSheet: _buildBottomActionBar(context),
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allulose Sweetener',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFB6D433), size: 20),
            const SizedBox(width: 5),
            Text(
              '4.8 (120 reviews)',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF2E5D32).withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 15),
            const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF2E5D32)),
            const SizedBox(width: 5),
            Text(
              'Free delivery',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF2E5D32).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$11.99',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E5D32),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFB6D433).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_rounded),
                color: const Color(0xFF2E5D32),
                onPressed: () {},
              ),
              Text(
                '1',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2E5D32),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                color: const Color(0xFF2E5D32),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Allulose is a rare sugar naturally found in small quantities in wheat, figs, and raisins. '
              'It has the same taste and texture as sugar but with minimal calories and no impact on blood sugar. '
              'Perfect for keto, diabetic, and low-carb diets.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Information',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E5D32),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildNutritionRow('Calories', '10 kcal'),
        _buildNutritionRow('Total Carbs', '4g'),
        _buildNutritionRow('Sugars', '0g'),
        _buildNutritionRow('Net Carbs', '0g'),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF2E5D32).withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E5D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF2E5D32).withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  color: const Color(0xFF2E5D32),
                  onPressed: () {},
                ),
                Text(
                  '1',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2E5D32),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  color: const Color(0xFF2E5D32),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB6D433),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Add to Cart',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
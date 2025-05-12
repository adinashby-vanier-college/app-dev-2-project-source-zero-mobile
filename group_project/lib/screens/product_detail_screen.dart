import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation.dart';
import '../routes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductImage(context),
                  _buildProductDetails(context),
                  _buildProductDescription(context),
                  _buildNutritionInfo(context),
                ],
              ),
            ),
          ),
          _buildBottomActionBar(context),
        ],
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/allulose.webp'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Allulose Sweetener',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
              Text(
                '4.8 (120 reviews)',
                style: GoogleFonts.lato(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.local_shipping_outlined, size: 20),
              const SizedBox(width: 5),
              Text(
                'Free delivery',
                style: GoogleFonts.lato(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$11.99',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Quantity',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {},
                    ),
                    const Text('1', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Allulose is a rare sugar naturally found in small quantities in wheat, figs, and raisins. '
                'It has the same taste and texture as sugar but with minimal calories and no impact on blood sugar. '
                'Perfect for keto, diabetic, and low-carb diets.',
            style: GoogleFonts.lato(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Information',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildNutritionRow('Calories', '10 kcal'),
          _buildNutritionRow('Total Carbs', '4g'),
          _buildNutritionRow('Sugars', '0g'),
          _buildNutritionRow('Net Carbs', '0g'),
        ],
      ),
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
              style: GoogleFonts.lato(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {},
                ),
                const Text('1', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  const SizedBox(width: 8),
                  Text(
                    'Add to Cart',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Our Products',
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
            _buildFilterOptions(context),
            const SizedBox(height: 30),
            _buildProductGrid(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildFilterOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.filter_alt_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sort, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Sort',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildProductCard(context, 'Organic Tomatoes', '\$3.99', 'assets/images/tomatoes.jpg'),
        _buildProductCard(context, 'Fresh Apples', '\$2.49', 'assets/images/apples.jpg'),
        _buildProductCard(context, 'Whole Grain Bread', '\$4.99', 'assets/images/bread.jpg'),
        _buildProductCard(context, 'Organic Milk', '\$5.49', 'assets/images/milk.jpg'),
        _buildProductCard(context, 'Carrots', '\$1.99', 'assets/images/carrots.jpg'),
        _buildProductCard(context, 'Bananas', '\$0.99', 'assets/images/bananas.jpg'),
        _buildProductCard(context, 'Organic Eggs', '\$4.49', 'assets/images/eggs.jpg'),
        _buildProductCard(context, 'Spinach', '\$2.99', 'assets/images/spinach.jpg'),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 35),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.productDetail);
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
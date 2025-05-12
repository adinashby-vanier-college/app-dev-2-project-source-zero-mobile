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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(context),
            const SizedBox(height: 20),
            _buildCategoriesRow(context),
            const SizedBox(height: 20),
            _buildFilterSortRow(context),
            const SizedBox(height: 20),
            _buildProductGrid(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search products...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesRow(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(context, 'All', true),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Food', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Beverages', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Supplements', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Personal Care', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      labelStyle: GoogleFonts.lato(
        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      onSelected: (bool selected) {},
    );
  }

  Widget _buildFilterSortRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.filter_alt_outlined, size: 18),
            label: Text(
              'Filters',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.sort, size: 18),
            label: Text(
              'Sort',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
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
        _buildProductCard(context, 'Allulose Sweetener', '\$11.99', 'assets/allulose.webp', 4.8),
        _buildProductCard(context, 'LMNT Electrolytes', '\$29.99', 'assets/LMNT.webp', 4.9),
        _buildProductCard(context, 'Gluten free Bread', '\$5.99', 'assets/carbonaut.webp', 4.5),
        _buildProductCard(context, 'Almond Butter', '\$9.49', 'assets/almondbutter.webp', 4.7),
        _buildProductCard(context, 'Protein Powder', '\$35.99', 'assets/proteinpowder.webp', 4.8),
        _buildProductCard(context, 'Cinnamon Sticks', '\$0.99', 'assets/cinnamon.jpg', 4.6),
        _buildProductCard(context, 'Moisturizer', '\$4.49', 'assets/moisturizer.webp', 4.4),
        _buildProductCard(context, 'Zero Sugar Candy', '\$2.99', 'assets/zerocandy.webp', 4.3),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String price, String imagePath, double rating) {
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
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.productDetail);
                  },
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
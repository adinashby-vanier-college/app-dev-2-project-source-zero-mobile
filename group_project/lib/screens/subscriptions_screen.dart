import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';
import '../widgets/bottom_navigation.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Subscriptions',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildPlanOptions(context),
            const SizedBox(height: 30),
            _buildCurrentPlan(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Plans',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the plan that works best for you',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Plans',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildPlanCard(
                context,
                title: 'Basic',
                price: '\$9.99',
                period: 'per month',
                features: [
                  'Weekly delivery',
                  '5 items per box',
                  'Standard quality produce',
                  'Email support',
                ],
                isRecommended: false,
                isCurrent: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPlanCard(
                context,
                title: 'Premium',
                price: '\$19.99',
                period: 'per month',
                features: [
                  'Twice weekly delivery',
                  '10 items per box',
                  'Premium quality produce',
                  'Priority support',
                  'Customizable preferences',
                ],
                isRecommended: true,
                isCurrent: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard(
      BuildContext context, {
        required String title,
        required String price,
        required String period,
        required List<String> features,
        required bool isRecommended,
        required bool isCurrent,
      }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isRecommended
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'RECOMMENDED',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: price,
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              children: [
                TextSpan(
                  text: ' $period',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrent
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
              foregroundColor: isCurrent
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: Text(
              isCurrent ? 'Current Plan' : 'Choose Plan',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlan(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Subscription',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_membership,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              'Premium Plan',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            subtitle: Text(
              'Active until July 15, 2023',
              style: GoogleFonts.lato(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Change Plan',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
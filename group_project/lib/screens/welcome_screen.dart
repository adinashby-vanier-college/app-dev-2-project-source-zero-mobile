import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left side - Green Section
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFB6D433),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          _buildLogo(context),
                          const SizedBox(height: 40),
                          Flexible(
                            child: Text(
                              'ZERO\nWASTED\nTIME,\nAT YOUR\nMOST\nTRUSTED\nSOURCE',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF004D40),
                                height: 1.2,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const Spacer(),
                          _buildAuthButtons(context),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Right side - Background Image
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/welcome_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(color: const Color(0xFFF5F5DC)),
                      _buildProductsDisplay(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Source',
            style: GoogleFonts.playfairDisplay(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF004D40),
            ),
          ),
          const SizedBox(width: 6),
          Image.asset(
            'assets/logo.png',
            height: 40,
            width: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF004D40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.leaf,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            'Zero',
            style: GoogleFonts.playfairDisplay(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF004D40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsDisplay(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/welcome_background.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.image,
                size: 40,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 20),
              Text(
                'Natural products coming soon...',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004D40),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.white.withOpacity(0.7),
                width: 1,
              ),
            ),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.login);
          },
          child: Text(
            'LOG IN',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF004D40),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: const Color(0xFF004D40).withOpacity(0.8),
                width: 1,
              ),
            ),
            elevation: 4,
            shadowColor: const Color(0xFF004D40).withOpacity(0.2),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.signup);
          },
          child: Text(
            'BEGIN YOUR JOURNEY',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}

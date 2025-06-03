import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left side - Clean White Section
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFFDFDFD),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          _buildModernLogo(context),
                          const SizedBox(height: 80),
                          _buildWelcomeText(context),
                          const Spacer(),
                          _buildModernAuthButtons(context),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Right side - Background Image with Overlay
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
                      // Subtle overlay to match the clean aesthetic
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color(0xFFFDFDFD).withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildModernLogo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFFB6D433),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'source',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF2E5D32),
                letterSpacing: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1,
              height: 24,
              color: const Color(0xFF2E5D32).withOpacity(0.3),
            ),
            Text(
              'zero',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E5D32),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Zero waste time at your most trusted source.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'welcome to',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'mindful\nshopping',
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF2E5D32),
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsDisplay(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/welcome_background.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E5D32).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB6D433).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.leaf,
                    size: 32,
                    color: Color(0xFF2E5D32),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'organic products\ncoming soon',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2E5D32),
                    letterSpacing: 0.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernAuthButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E5D32).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.login);
            },
            child: Text(
              'log in',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E5D32).withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E5D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: const Color(0xFF2E5D32).withOpacity(0.1),
                  width: 1,
                ),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.signup);
            },
            child: Text(
              'begin your journey',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

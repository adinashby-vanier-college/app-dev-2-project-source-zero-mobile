import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './routes.dart';

class SourceZeroApp extends StatelessWidget {
  const SourceZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Source Zero',
      debugShowCheckedModeBanner: false,

      // ✅ Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('es'), // Add more supported locales as needed
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      // ✅ Theme
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5D32),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2E5D32),
          secondary: const Color(0xFF388E3C),
          tertiary: const Color(0xFFFADDD1),
          background: const Color(0xFFFFF8E7),
        ),
        textTheme: _buildTextTheme(),
        buttonTheme: _buildButtonTheme(),
        cardTheme: _buildCardTheme(),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        outlinedButtonTheme: _buildOutlinedButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFF8E7),
      ),

      // ✅ Routing
      initialRoute: Routes.welcome,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  TextTheme _buildTextTheme() {
    return GoogleFonts.playfairDisplayTextTheme().copyWith(
      displayLarge: const TextStyle(
        color: Color(0xFF2E5D32),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      displayMedium: const TextStyle(
        color: Color(0xFF2E5D32),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      headlineLarge: const TextStyle(
        color: Color(0xFF2E5D32),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      headlineMedium: const TextStyle(
        color: Color(0xFF2E5D32),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        color: const Color(0xFF2E5D32),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.lato(
        color: const Color(0xFF1F3B22),
      ),
      bodyMedium: GoogleFonts.lato(
        color: const Color(0xFF1F3B22),
      ),
    );
  }

  ButtonThemeData _buildButtonTheme() {
    return ButtonThemeData(
      buttonColor: const Color(0xFF2E5D32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  CardTheme _buildCardTheme() {
    return CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E5D32),
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2E5D32),
        side: const BorderSide(color: Color(0xFF2E5D32), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: const Color(0xFF2E5D32).withOpacity(0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF2E5D32), width: 2),
      ),
      hintStyle: GoogleFonts.lato(
        color: Colors.grey.shade500,
        fontSize: 16,
      ),
    );
  }
}

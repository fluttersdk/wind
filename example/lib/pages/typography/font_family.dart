import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FontFamilyExamplePage extends StatelessWidget {
  const FontFamilyExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(
        fontFamilies: {
          'sans': GoogleFonts.inter().fontFamily!,
          'serif': GoogleFonts.merriweather().fontFamily!,
          'mono': GoogleFonts.jetBrainsMono().fontFamily!,
          'display': GoogleFonts.poppins().fontFamily!,
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WText("font-sans (Inter)", className: "font-sans text-lg"),
              const SizedBox(height: 16),
              WText(
                "font-serif (Merriweather)",
                className: "font-serif text-lg",
              ),
              const SizedBox(height: 16),
              WText(
                "font-mono (JetBrains Mono)",
                className: "font-mono text-lg",
              ),
              const SizedBox(height: 16),
              WText(
                "font-display (Poppins)",
                className: "font-display text-lg font-semibold",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/hive_service.dart';
import 'providers/content_provider.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider()..init()),
      ],
      child: const LiteraApp(),
    ),
  );
}

class LiteraApp extends StatelessWidget {
  const LiteraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LITERA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: const Color(0xFF483F29),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF483F29),
          secondary: Color(0xFF7A774A),
          surface: Color(0xFFDFD7C7),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          displayMedium: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          displaySmall: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          headlineLarge: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          headlineMedium: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          headlineSmall: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          titleLarge: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          titleMedium: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          titleSmall: GoogleFonts.playfairDisplay(color: const Color(0xFF483F29)),
          bodyLarge: GoogleFonts.inter(color: const Color(0xFF483F29)),
          bodyMedium: GoogleFonts.inter(color: const Color(0xFF483F29)),
          bodySmall: GoogleFonts.inter(color: const Color(0xFF483F29)),
          labelLarge: GoogleFonts.inter(color: const Color(0xFF483F29)),
          labelMedium: GoogleFonts.inter(color: const Color(0xFF483F29)),
          labelSmall: GoogleFonts.inter(color: const Color(0xFF483F29)),
        ),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            Container(color: const Color(0xFFDFD7C7)), // Base fallback color
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/paper_texture.jpg',
                  repeat: ImageRepeat.repeat,
                  color: const Color(0xFFDFD7C7),
                  colorBlendMode: BlendMode.multiply,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
              ),
            ),
            if (child != null) child,
          ],
        );
      },
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/hive_service.dart';
import 'providers/content_provider.dart';
import 'screens/home_screen.dart';

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
        scaffoldBackgroundColor: const Color(0xFFDFD7C7),
        primaryColor: const Color(0xFF483F29),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF483F29),
          secondary: Color(0xFF7A774A),
          surface: Color(0xFFDFD7C7),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Sans-Serif', color: Color(0xFF483F29)),
          bodyMedium: TextStyle(fontFamily: 'Sans-Serif', color: Color(0xFF483F29)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ===================================================================
// DOSYA: lib/main.dart
// ===================================================================
import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart';
import 'screens/case_selection_screen.dart';
import 'services/profile_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final profileService = ProfileService();
  final bool hasProfile = await profileService.hasProfile();
  runApp(MidnightConfessionGame(hasProfile: hasProfile));
}

class MidnightConfessionGame extends StatelessWidget {
  final bool hasProfile;
  const MidnightConfessionGame({super.key, required this.hasProfile});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midnight Confession',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ),
      home: hasProfile ? const CaseSelectionScreen() : const MainMenuScreen(),
    );
  }
}

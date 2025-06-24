import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart';
import 'screens/case_selection_screen.dart';
import 'services/profile_service.dart';

// main fonksiyonunu async yapıyoruz çünkü profil kontrolü zaman alabilir.
Future<void> main() async {
  // Flutter'ın başlatma işlemlerinin tamamlandığından emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();
  
  // YENİ: ProfileService'i kullanarak kayıtlı bir profil olup olmadığını kontrol ediyoruz.
  final profileService = ProfileService();
  final bool hasProfile = await profileService.hasProfile();

  runApp(MidnightConfessionGame(hasProfile: hasProfile));
}

class MidnightConfessionGame extends StatelessWidget {
  // YENİ: Başlangıç ekranını belirlemek için bu bilgiyi alıyoruz.
  final bool hasProfile;
  
  const MidnightConfessionGame({super.key, required this.hasProfile});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midnight Confession',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        primaryColor: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // YENİ: `hasProfile` değişkenine göre hangi ekranın gösterileceğine karar veriyoruz.
      home: hasProfile ? const CaseSelectionScreen() : const MainMenuScreen(),
    );
  }
}

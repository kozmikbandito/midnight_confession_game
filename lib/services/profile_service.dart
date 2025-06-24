import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profile_creation_screen.dart'; // Gender enum'ını kullanmak için

// Oyuncunun profil bilgilerini tutacak basit bir sınıf.
class DetectiveProfile {
  final String name;
  final Gender gender;

  DetectiveProfile({required this.name, required this.gender});
}

// Bu sınıf, oyuncu profilini telefon hafızasına kaydetmek ve okumaktan sorumludur.
class ProfileService {
  static const _nameKey = 'detective_name';
  static const _genderKey = 'detective_gender';

  // Profil bilgilerini kaydeder.
  Future<void> saveProfile(String name, Gender gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    // enum'ı String olarak kaydediyoruz.
    await prefs.setString(_genderKey, gender.toString());
  }

  // Kayıtlı bir profil olup olmadığını kontrol eder.
  Future<bool> hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_nameKey);
  }

  // Kayıtlı profili okur.
  Future<DetectiveProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final genderString = prefs.getString(_genderKey);

    if (name == null || genderString == null) {
      return null;
    }

    // Kaydettiğimiz String'i tekrar Gender enum'ına çeviriyoruz.
    final gender = Gender.values.firstWhere(
      (e) => e.toString() == genderString,
      orElse: () => Gender.male, // Bir hata olursa varsayılan olarak erkek seç.
    );

    return DetectiveProfile(name: name, gender: gender);
  }
}
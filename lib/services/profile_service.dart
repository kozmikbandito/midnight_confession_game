// ===================================================================
// DOSYA: lib/services/profile_service.dart
// ===================================================================
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profile_creation_screen.dart'; 

class DetectiveProfile {
  final String name;
  final Gender gender;
  DetectiveProfile({required this.name, required this.gender});
}

class ProfileService {
  static const _nameKey = 'detective_name';
  static const _genderKey = 'detective_gender';

  Future<void> saveProfile(String name, Gender gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_genderKey, gender.toString());
  }

  Future<bool> hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_nameKey);
  }

  Future<DetectiveProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final genderString = prefs.getString(_genderKey);
    if (name == null || genderString == null) return null;
    final gender = Gender.values.firstWhere((e) => e.toString() == genderString, orElse: () => Gender.male);
    return DetectiveProfile(name: name, gender: gender);
  }
}
// ===================================================================
// DOSYA: lib/screens/profile_creation_screen.dart
// ===================================================================
import 'package:flutter/material.dart';
import 'case_selection_screen.dart'; 
import '../services/profile_service.dart';

enum Gender { male, female }

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});
  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  String _detectiveName = '';
  Gender _selectedGender = Gender.male;

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _profileService.saveProfile(_detectiveName, _selectedGender);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CaseSelectionScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil kaydedilirken bir hata oluştu: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarIcon = _selectedGender == Gender.male ? Icons.person_outline : Icons.person_outline_sharp;
    return Scaffold(
      appBar: AppBar(title: const Text('Dedektif Profilini Oluştur'), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24.0), child: Form(key: _formKey, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(avatarIcon, size: 120, color: Colors.teal.shade200),
        const SizedBox(height: 20),
        Text('Kimliğinizi Belirleyin', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
        const SizedBox(height: 40),
        TextFormField(decoration: const InputDecoration(labelText: 'Dedektif Adı', border: OutlineInputBorder()), validator: (value) { if (value == null || value.trim().isEmpty) return 'Lütfen bir isim girin.'; return null; }, onSaved: (value) { _detectiveName = value!; }),
        const SizedBox(height: 30),
        const Text('Cinsiyet', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ChoiceChip(label: const Text('Erkek'), selected: _selectedGender == Gender.male, onSelected: (selected) { if (selected) setState(() => _selectedGender = Gender.male); }),
          const SizedBox(width: 20),
          ChoiceChip(label: const Text('Kadın'), selected: _selectedGender == Gender.female, onSelected: (selected) { if (selected) setState(() => _selectedGender = Gender.female); }),
        ]),
        const SizedBox(height: 50),
        ElevatedButton(onPressed: _submitProfile, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), backgroundColor: Colors.teal, foregroundColor: Colors.white, textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), child: const Text('Soruşturmaya Başla')),
      ])))),
    );
  }
}
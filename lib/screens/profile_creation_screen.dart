import 'package:flutter/material.dart';
import 'case_selection_screen.dart'; 
// YENİ: Profil servisimizi import ediyoruz.
import '../services/profile_service.dart';

// Cinsiyet seçenekleri için bir enum oluşturmak kodu daha okunabilir kılar.
enum Gender { male, female }

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  // Formu kontrol etmek için bir key.
  final _formKey = GlobalKey<FormState>();
  // YENİ: Profil servisini kullanmak için bir nesne oluşturuyoruz.
  final ProfileService _profileService = ProfileService();
  
  // Girilen verileri tutacak değişkenler.
  String _detectiveName = '';
  Gender _selectedGender = Gender.male;

  // GÜNCELLEME: Butona tıklandığında çalışacak fonksiyon artık async.
  Future<void> _submitProfile() async {
    // Formun geçerli olup olmadığını kontrol et.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // onSaved fonksiyonlarını çalıştır.
      
      try {
        // YENİ: Profil servisini kullanarak verileri kaydediyoruz.
        await _profileService.saveProfile(_detectiveName, _selectedGender);

        // Bir sonraki ekrana geçmeden önce 'context'in hala geçerli olup olmadığını
        // kontrol etmek en iyi pratiktir.
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CaseSelectionScreen(),
          ),
        );
      } catch (e) {
        // Hata olursa kullanıcıya bilgi ver.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil kaydedilirken bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Seçilen cinsiyete göre gösterilecek avatar ikonu.
    final avatarIcon = _selectedGender == Gender.male
        ? Icons.person_outline
        : Icons.person_outline_sharp;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dedektif Profilini Oluştur'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar Gösterimi
                Icon(avatarIcon, size: 120, color: Colors.teal.shade200),
                const SizedBox(height: 20),
                Text(
                  'Kimliğinizi Belirleyin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 40),

                // İsim Giriş Alanı
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Dedektif Adı',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen bir isim girin.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _detectiveName = value!;
                  },
                ),
                const SizedBox(height: 30),

                // Cinsiyet Seçimi
                const Text('Cinsiyet', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Erkek'),
                      selected: _selectedGender == Gender.male,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedGender = Gender.male;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    ChoiceChip(
                      label: const Text('Kadın'),
                      selected: _selectedGender == Gender.female,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedGender = Gender.female;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Onay Butonu
                ElevatedButton(
                  onPressed: _submitProfile, // GÜNCELLEME: Yeni fonksiyonu çağırıyoruz.
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Soruşturmaya Başla'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'profile_creation_screen.dart'; // Profil oluşturma ekranımızı import ediyoruz

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Şık bir gradyan arka plan ekleyelim.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Oyunun Adı
              Text(
                'Midnight Confession',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 2,
                ),
              ),
              Text(
                'A Detective Story',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade400,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 100),

              // Yeni Soruşturma Butonu
              ElevatedButton(
                // GÜNCELLEME: onPressed fonksiyonunu dolduruyoruz.
                onPressed: () {
                  // Navigator.push, yeni bir ekranı eskisinin üzerine yığarak
                  // bir sonraki sayfaya geçmemizi sağlar.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileCreationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Yeni Soruşturma'),
              ),
              const SizedBox(height: 20),

              // Devam Et Butonu (Şimdilik pasif)
              ElevatedButton(
                onPressed: null, // null olması, butonu pasif hale getirir.
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Devam Et'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
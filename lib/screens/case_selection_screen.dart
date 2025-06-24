import 'package:flutter/material.dart';
import '../services/case_loader_service.dart'; // YENİ: Vaka yükleyici servisini import ediyoruz.
import 'case_brief_screen.dart'; 

class CaseSelectionScreen extends StatefulWidget {
  const CaseSelectionScreen({super.key});

  @override
  State<CaseSelectionScreen> createState() => _CaseSelectionScreenState();
}

class _CaseSelectionScreenState extends State<CaseSelectionScreen> {
  // YENİ: Servis sınıfımızdan bir nesne oluşturuyoruz.
  final CaseLoaderService _loader = CaseLoaderService();
  
  List<Map<String, String>> _cases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  // GÜNCELLEME: Bu fonksiyon artık tüm işi servisimize devrediyor.
  Future<void> _loadCases() async {
    try {
      final loadedCases = await _loader.getAvailableCases();
      
      setState(() {
        _cases = loadedCases;
        _isLoading = false;
      });

    } catch (e) {
      print('Vakalar yüklenirken hata oluştu: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bir Vaka Seç'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cases.length,
              itemBuilder: (context, index) {
                final vaka = _cases[index];
                final caseTitle = vaka['title']!;
                final casePath = vaka['path']!;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.folder_open, color: Colors.teal),
                    title: Text(caseTitle),
                    subtitle: Text('Bölüm ${index + 1}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CaseBriefScreen(casePath: casePath),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
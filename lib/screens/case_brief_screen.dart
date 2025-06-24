import 'package:flutter/material.dart';
import '../services/case_loader_service.dart';
import '../models/case_model.dart';
import 'investigation_screen.dart'; 

class CaseBriefScreen extends StatefulWidget {
  final String casePath;

  const CaseBriefScreen({super.key, required this.casePath});

  @override
  State<CaseBriefScreen> createState() => _CaseBriefScreenState();
}

class _CaseBriefScreenState extends State<CaseBriefScreen> {
  final CaseLoaderService _loader = CaseLoaderService();
  CaseModel? _caseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaseDetails();
  }

  Future<void> _loadCaseDetails() async {
    try {
      final loadedCase = await _loader.loadCase(widget.casePath);
      setState(() {
        _caseData = loadedCase;
        _isLoading = false;
      });
    } catch (e) {
      // print('Vaka detayları yüklenirken hata: $e'); // DÜZELTME
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vaka dosyası yüklenemedi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _caseData == null
                ? const Center(child: Text('Vaka yüklenemedi.', style: TextStyle(color: Colors.white)))
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.folder_special_outlined, size: 80, color: Colors.tealAccent),
                        const SizedBox(height: 20),
                        Text(
                          _caseData!.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _caseData!.brief,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade300,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => InvestigationScreen(caseData: _caseData!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Soruşturmayı Başlat',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
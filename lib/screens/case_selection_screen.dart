import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'case_brief_screen.dart';

class CaseSelectionScreen extends StatefulWidget {
  const CaseSelectionScreen({super.key});

  @override
  State<CaseSelectionScreen> createState() => _CaseSelectionScreenState();
}

class _CaseSelectionScreenState extends State<CaseSelectionScreen> {
  List<Map<String, String>> _cases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      final casePaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/cases/'))
          .where((String key) => key.toLowerCase().endsWith('.json'))
          .toList();

      List<Map<String, String>> loadedCases = [];
      for (var path in casePaths) {
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = json.decode(jsonString);
        loadedCases.add({
          'path': path,
          'title': jsonMap['title'] ?? 'İsimsiz Vaka',
        });
      }
      
      setState(() {
        _cases = loadedCases;
        _isLoading = false;
      });

    } catch (e) {
      // print('Vakalar yüklenirken hata oluştu: $e'); // DÜZELTME
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
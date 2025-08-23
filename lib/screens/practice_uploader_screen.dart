import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeUploaderScreen extends StatefulWidget {
  @override
  _PracticeUploaderScreenState createState() => _PracticeUploaderScreenState();
}

class _PracticeUploaderScreenState extends State<PracticeUploaderScreen> {
  List<dynamic> _practices = [];
  String statusMessage = "";
  bool isUploading = false;

  Future<void> _pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      try {
        final parsed = json.decode(content);
        if (parsed is List) {
          setState(() {
            _practices = parsed;
            statusMessage = "✅ File loaded. Ready to preview.";
          });
        } else {
          setState(() {
            statusMessage = "⚠️ JSON must be a list of practices.";
          });
        }
      } catch (e) {
        setState(() {
          statusMessage = "❌ Failed to parse JSON: $e";
        });
      }
    }
  }

  Future<void> _uploadPractices() async {
    setState(() {
      isUploading = true;
      statusMessage = "Uploading...";
    });

    try {
      final collection = FirebaseFirestore.instance.collection('advanced_practices');

      final oldDocs = await collection.get();
      for (var doc in oldDocs.docs) {
        await doc.reference.delete();
      }

      for (var practice in _practices) {
        if (practice['title'] != null &&
            practice['description'] != null &&
            practice['duration'] != null) {
          await collection.add({
            'title': practice['title'],
            'description': practice['description'],
            'duration': practice['duration'],
          });
        }
      }

      setState(() {
        statusMessage = "✨ Practices uploaded successfully!";
      });
    } catch (e) {
      setState(() {
        statusMessage = "❌ Upload failed: $e";
      });
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _showPreviewModal() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🔍 Practice Preview", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _practices.length,
                    itemBuilder: (context, index) {
                      final item = _practices[index];
                      final isValid = item['title'] != null &&
                          item['description'] != null &&
                          item['duration'] != null;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isValid ? Colors.transparent : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("🧘 ${item['title'] ?? '❌ Missing Title'}",
                                  style: TextStyle(color: isValid ? Colors.purpleAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['description'] ?? '❌ Missing Description', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 2),
                              Text("⏳ ${item['duration'] ?? '❌ Missing Duration'}", style: const TextStyle(color: Colors.white38)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _uploadPractices();
                  },
                  child: const Text("✅ Confirm & Upload", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("📤 JSON Practice Uploader"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: isUploading ? null : _pickJsonFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("📁 Select JSON File", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              if (_practices.isNotEmpty)
                ElevatedButton(
                  onPressed: isUploading ? null : _showPreviewModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("🔍 Preview & Upload", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              const SizedBox(height: 24),
              Text(
                statusMessage,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
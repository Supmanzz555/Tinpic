// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tinpic/pages/confirmup.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Future<void> _pickImages() async {
    final picker = await ImagePicker().pickMultiImage();
    if (picker != null && picker.isNotEmpty) {
      final imageFiles = picker.map((file) => File(file.path)).toList();

      // to confirm page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmUploadPage(imageFiles: imageFiles),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's upload your pics:)", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber[200],
        centerTitle: true,
      ),

      backgroundColor: const Color.fromARGB(255, 152, 152, 152),

      // select button
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.photo, size: 24),
          label: const Text("Select Pics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 15, 14, 13),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tinpic/API/services.dart';

class ConfirmUploadPage extends StatefulWidget {
  final List<File> imageFiles;

  const ConfirmUploadPage({super.key, required this.imageFiles});

  @override
  State<ConfirmUploadPage> createState() => _ConfirmUploadPageState();
}

class _ConfirmUploadPageState extends State<ConfirmUploadPage> {
  bool _isUploading = false;
  final ApiServices _apiServices = ApiServices();

  Future<void> _uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    for (var imageFile in widget.imageFiles) {
      final response = await _apiServices.uploadImage(imageFile);
      if (response.isNotEmpty && response['image_id'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Uploaded: ${response['image_id']}"),duration: const Duration(seconds: 1)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload an image") ,duration: Duration(seconds: 1),),
        );
      }
    }

    setState(() {
      _isUploading = false;
    });

    Navigator.pop(context); // Go back after upload
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Are you sure to upload these?", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.amber[200],
      ),

      backgroundColor: const Color.fromARGB(255, 152, 152, 152),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: widget.imageFiles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Image.file(
              widget.imageFiles[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),

      // button to confirm uploading
      floatingActionButton: _isUploading
          ? const CircularProgressIndicator()
          : FloatingActionButton.extended(
              onPressed: _uploadImages,
              label: const Text("Upload All"),
              icon: const Icon(Icons.cloud_upload),
              backgroundColor: Colors.amber[700],
            ),
    );
  }
}

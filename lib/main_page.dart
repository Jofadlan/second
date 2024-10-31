import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedImageFile;
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void dispose() {
    _keteranganController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalController.text = "${pickedDate.day}, ${pickedDate.month}, ${pickedDate.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImageFile = File(image.path);
      });
    }
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Form Submitted"),
        content: Text("Selected Image: ${selectedImageFile?.path}\nKeterangan: ${_keteranganController.text}\nTanggal: ${_tanggalController.text}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: const Center(
          child: Text(
            'Beranda',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Unggah Gambar", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedImageFile != null ? "Gambar Terpilih" : "Pilih Gambar",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.image),
                    ],
                  ),
                ),
              ),
              if (selectedImageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.file(
                    selectedImageFile!,
                    height: 150,
                  ),
                ),
              const SizedBox(height: 16),
              const Text("Keterangan", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  hintText: "Keterangan...",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Tanggal", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  hintText: "12, 12, 2023",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                readOnly: true,
                onTap: _pickDate,
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      "KIRIM",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
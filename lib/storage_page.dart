import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class StoragePage extends StatelessWidget {
  const StoragePage({super.key});

  Future<void> _confirmDelete(BuildContext context, String docId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this submission?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      await FirebaseFirestore.instance.collection('submissions').doc(docId).delete();
    }
  }

  Future<void> _confirmEdit(BuildContext context, String docId, Map<String, dynamic> data) async {
    final TextEditingController _keteranganController = TextEditingController(text: data['keterangan']);
    final TextEditingController _tanggalController = TextEditingController(text: data['tanggal']);

    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Submission"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _keteranganController,
              decoration: const InputDecoration(labelText: "Keterangan"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tanggalController,
              decoration: const InputDecoration(labelText: "Tanggal"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _tanggalController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                }
              },
              readOnly: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Save"),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      await FirebaseFirestore.instance.collection('submissions').doc(docId).update({
        'keterangan': _keteranganController.text,
        'tanggal': _tanggalController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[800],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('submissions').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No submissions yet."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data['imagePath'] != null)
                        Image.file(
                          File(data['imagePath']),
                          height: 100,
                          width: 100,
                        ),
                      const SizedBox(height: 8),
                      Text("Keterangan: ${data['keterangan']}"),
                      const SizedBox(height: 4),
                      Text("Tanggal: ${data['tanggal']}"),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            label: const Text("Edit"),
                            onPressed: () => _confirmEdit(context, doc.id, data),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text("Delete"),
                            onPressed: () => _confirmDelete(context, doc.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

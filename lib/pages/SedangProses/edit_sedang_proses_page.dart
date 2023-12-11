import 'package:flutter/material.dart';

class EditSedangProsesPage extends StatefulWidget {
  const EditSedangProsesPage({super.key});

  @override
  State<EditSedangProsesPage> createState() => _EditSedangProsesPageState();
}

class _EditSedangProsesPageState extends State<EditSedangProsesPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Laporan',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: 'Masukkan title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                hintText: 'Masukkan description', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Edit'),
          )
        ],
      ),
    );
  }
}

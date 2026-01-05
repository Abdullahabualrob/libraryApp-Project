import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookPage extends StatefulWidget {
  const EditBookPage({super.key});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {

  final _formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final copiesCtrl = TextEditingController();

  late DocumentSnapshot book;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    book = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    final data = book.data() as Map<String, dynamic>;

    titleCtrl.text = data["title"];
    authorCtrl.text = data["author"];
    imageCtrl.text = data["imageUrl"];
    copiesCtrl.text = data["totalCopies"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Book"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Book Title"),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter title" : null,
              ),

              TextFormField(
                controller: authorCtrl,
                decoration: const InputDecoration(labelText: "Author"),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter author" : null,
              ),

              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),

              TextFormField(
                controller: copiesCtrl,
                decoration: const InputDecoration(labelText: "Total Copies"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? "Enter number" : null,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {

                    await book.reference.update({
                      "title": titleCtrl.text,
                      "author": authorCtrl.text,
                      "imageUrl": imageCtrl.text,
                      "totalCopies": int.parse(copiesCtrl.text),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Book updated successfully")),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

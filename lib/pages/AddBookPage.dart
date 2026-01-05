import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final imageController = TextEditingController();
  final copiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Book"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: titleController,
                decoration:InputDecoration(
                    labelText: "Book Title"
                ),
                validator: (v){
                  if(v==null || v.isEmpty) return "Enter title";
                  return null;
                },
              ),

              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: "Author"),
                validator: (v){
                  if(v==null || v.isEmpty) return "Enter author";
                  return null;
                },
              ),

              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),

              TextFormField(
                controller: copiesController,
                decoration: const InputDecoration(labelText: "Total Copies"),
                validator: (v){
                  if(v==null || v.isEmpty) return "Enter number";
                  return null;
                },
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                onPressed: () async {
                  if(_formKey.currentState!.validate()){

                    int total = int.parse(copiesController.text);

                    await FirebaseFirestore.instance
                        .collection("books")
                        .add({
                      "title": titleController.text,
                      "author": authorController.text,
                      "imageUrl": imageController.text,
                      "totalCopies": total,
                      "availableCopies": total,
                      "createdAt": Timestamp.now(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },

                child: const Text(
                  "Add Book",
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

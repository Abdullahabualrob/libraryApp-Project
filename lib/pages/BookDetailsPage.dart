import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final DocumentSnapshot book =
    ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    final data = book.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if ((data["imageUrl"] ?? "").toString().isNotEmpty)
              Center(
                child: Image.network(
                  data["imageUrl"],
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(height: 20),

            Text(
              data["title"] ?? "Book",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            Text("Author: ${data["author"] ?? "Unknown"}"),

            SizedBox(height: 10),

            Text(
              "Available copies: ${data["availableCopies"]}",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 10),

            if (data["returnDate"] != null)
              Text(
                "Return date: ${data["returnDate"].toDate().toString().substring(0, 16)}",
                style: TextStyle(fontSize: 16),
              ),

            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () async {

                if ((data["availableCopies"] ?? 0) > 0) {

                  try {

                    final uid =
                        FirebaseAuth.instance.currentUser!.uid;

                    await FirebaseFirestore.instance.collection("borrows").add({
                      "userId": uid,
                      "bookId": book.id,
                      "borrowDate": Timestamp.now(),

                      // 👇 أهم تعديل
                      "returnDate": data["returnDate"],
                    });

                    await book.reference.update({
                      "availableCopies": FieldValue.increment(-1)
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Book borrowed successfully")),
                    );

                  } catch (e) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No copies available")),
                  );
                }
              },

              child: Text(
                "Borrow Book",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

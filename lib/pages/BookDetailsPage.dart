import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final DocumentSnapshot book = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

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

              Center(
                child: Image.network(
                  data["imageUrl"],
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(height: 20),

            Center(
              child: Text(
                data["title"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 5),

            Center(child: Text("Author: ${data["author"] }")),

            SizedBox(height: 10),

            Center(
              child: Text(
                "Available copies: ${data["availableCopies"]}",
                style: TextStyle(fontSize: 16),
              ),
            ),


            SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () async {

                  if ((data["availableCopies"] ?? 0) > 0) {

                    try {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final borrowDate = DateTime.now();
                      final returnDate = borrowDate.add(Duration(days: 7));

                      final user = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .get();

                      final userdata = user.data() as Map<String, dynamic> ;

                      await FirebaseFirestore.instance.collection("borrows").add({
                        "userId": uid,
                        "bookId": book.id,
                        "borrowDate": Timestamp.now(),
                        "returnDate": Timestamp.fromDate(returnDate),
                        "Name":userdata["name"],
                        "BookName": data["title"]

                      });

                      await FirebaseFirestore.instance
                          .collection("books")
                          .doc(book.id).update({
                        "availableCopies":FieldValue.increment(-1)
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Book borrowed successfully")),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
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
            ),
          ],
        ),
      ),
    );
  }
}

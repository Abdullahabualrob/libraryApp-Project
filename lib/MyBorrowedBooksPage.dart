import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBorrowedBooksPage extends StatelessWidget {
  const MyBorrowedBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Borrowed Books"),
          backgroundColor: Colors.red,
        ),
        body: const Center(
          child: Text("Please login first"),
        ),
      );
    }

    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Borrowed Books"),
        backgroundColor: Colors.red,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("borrows")
            .where("userId", isEqualTo: uid)
            .where("returnDate", isEqualTo: null)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You have not borrowed any books yet 📚"),
            );
          }

          final borrows = snapshot.data!.docs;

          return ListView.builder(
            itemCount: borrows.length,
            itemBuilder: (context, index) {

              final borrow = borrows[index];
              final bookId = borrow["bookId"];

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("books")
                    .doc(bookId)
                    .get(),

                builder: (context, bookSnap) {

                  if (!bookSnap.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final book = bookSnap.data!;
                  final data = book.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 3,

                    child: ListTile(
                      leading: data["imageUrl"] != null
                          ? Image.network(
                        data["imageUrl"],
                        width: 55,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.menu_book, color: Colors.red),

                      title: Text(
                        data["title"] ?? "Unknown title",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),

                          Text("Author: ${data["author"] ?? "Unknown"}"),

                          Text("Available copies: ${data["availableCopies"]}"),

                          Text(
                            "Borrowed on: "
                                "${borrow["borrowDate"].toDate().toString().substring(0, 16)}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios),

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: book,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

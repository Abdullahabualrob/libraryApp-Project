import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBorrowedBooksPage extends StatelessWidget {
  const MyBorrowedBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Borrowed Books"),
        backgroundColor: Colors.red,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("borrows").where("userId", isEqualTo: user).snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return  Center(child: Text("No borrowed books"));
          }

          final borrows = snapshot.data!.docs;

          return ListView.builder(
            itemCount: borrows.length,
            itemBuilder: (context, index) {

              final borrow = borrows[index];
              final dataBorrow=borrow.data();
              final bookId = dataBorrow["bookId"];


              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("books")
                    .doc(bookId)
                    .get(),

                builder: (context, bookSnap) {

                  if (!bookSnap.hasData || bookSnap.data!.data() == null) {
                    return  SizedBox() ;
                  }

                 final dataBook=bookSnap.data!.data() as Map<String,dynamic>;

                  return ListTile(
                    leading: Image.network(dataBook["imageUrl"], width: 50, fit: BoxFit.cover) ,

                    title: Text(dataBook["title"] ),
                    subtitle: Text(
                      "Return before: ""${dataBorrow["returnDate"].toDate()}",
                    ),

                    onTap: () {
                      Navigator.pushNamed(context, '/details', arguments: bookSnap.data);
                    },
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

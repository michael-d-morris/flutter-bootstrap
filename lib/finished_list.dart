import 'package:bootstrap/book.dart';
import 'package:bootstrap/book_display.dart';
import 'package:bootstrap/navbar%20helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<Book> _finishedBooks = [];

class FinishedListPage extends StatefulWidget {
  const FinishedListPage({super.key});

  @override
  State<FinishedListPage> createState() => _FinishedListPage();
}

class _FinishedListPage extends State<FinishedListPage> {
  _FinishedListPage() {
    FirebaseDatabase.instance
        .ref("books/finished")
        .onValue
        .listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (event.snapshot.exists) {
        final data = snapshot.value as Map;

        List<Book> finishedBooksTemp = [];
        data.forEach((key, value) {
          finishedBooksTemp.add(
              Book(
                  id: key,
                  title: value["title"],
                  author: value["author"],
                  genre: value["genre"],
                  rating: value["rating"],
                  isFinished: value["isFinished"],
                  imageLink: value["imageLink"]
              )
          );
        });
        _finishedBooks = finishedBooksTemp;
        setState(() {

        });
      }
      else {
        _finishedBooks = [];
      }
    });
  }

  late List<Book> _filteredFinishedBooks = [];

  @override
  void initState() {
    _filteredFinishedBooks = _finishedBooks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: const Text(
          "Currently Finished",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: "Search for a book",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String input) {
                      _filteredFinishedBooks = [];
                      for(Book b in _finishedBooks) {
                        if(b.title.toLowerCase().contains(input.toLowerCase())) {
                          _filteredFinishedBooks.add(b);
                        }
                      }
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                    flex: 13,
                    child: ListView.builder(
                      itemCount: _filteredFinishedBooks.length,
                      itemBuilder: (context, index) {
                        return BookDisplayHelper(
                            book: _filteredFinishedBooks[index]
                        );
                      },
                    )
                ),
                const NavBarHelper()
              ],
            ),
          )
      ),
    );
  }
}

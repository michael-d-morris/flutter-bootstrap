import 'package:bootstrap/book.dart';
import 'package:bootstrap/book_display.dart';
import 'package:bootstrap/navbar%20helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<Book> _readingBooks = [];

class ReadingListPage extends StatefulWidget {
  const ReadingListPage({super.key});

  @override
  State<ReadingListPage> createState() => _ReadingListPage();
}

class _ReadingListPage extends State<ReadingListPage> {
  _ReadingListPage() {
    refresh();
  }
  void refresh() {
    FirebaseDatabase.instance
        .ref("books/reading")
        .onValue
        .listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if(event.snapshot.exists) {
        final data = snapshot.value as Map;

        List<Book> readingBooksTemp = [];
        data.forEach((key, value) {
          readingBooksTemp.add(
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
        _readingBooks = readingBooksTemp;
        setState(() {

        });
      }
      else {
        _readingBooks = [];
      }
    });
  }

  List<Book> _filteredReadingBooks = [];

  @override
  void initState() {
    _filteredReadingBooks = _readingBooks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: const Text(
          "Currently Reading",
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
                    _filteredReadingBooks = [];
                    for(Book b in _readingBooks) {
                      if(b.title.toLowerCase().contains(input.toLowerCase())) {
                        _filteredReadingBooks.add(b);
                      }
                    }
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                flex: 13,
                child: ListView.builder(
                  itemCount: _filteredReadingBooks.length,
                  itemBuilder: (context, index) {
                    return BookDisplayHelper(
                      book: _filteredReadingBooks[index]
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

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'book.dart';
import 'package:http/http.dart' as http;

const List<int> rating = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class BookDisplayHelper extends StatelessWidget {

  final Book book;

  const BookDisplayHelper({
    super.key,
    required this.book,
  });

  Future<void> fetchImage() async {
    try {
      if(book.imageLink.isNotEmpty) {
        final response = await http.get(Uri.parse(book.imageLink));
        await Future.delayed(const Duration(milliseconds: 1000));
        if(response.statusCode == 200) {
          print("${book.title}: Successfully Connected");
        }
      }
    }
    catch (error) {
      FirebaseDatabase.instance.ref().child("books/reading/${book.id}").update(
          {
            "title" : book.title,
            "author" : book.author,
            "genre" : book.genre,
            "rating" : book.rating,
            "isFinished" : book.isFinished,
            "imageLink" : ""
          }
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: FutureBuilder (
              future: fetchImage(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()
                  );
                }
                if(snapshot.hasError) {
                  return Image.asset("assets/no_image.jpg", height: double.infinity, width: 200, fit: BoxFit.fitHeight);
                }
                else {
                  return book.imageLink.isNotEmpty ? Image.network(book.imageLink, height: double.infinity, width: double.infinity, fit: BoxFit.cover) : Image.asset("assets/no_image.jpg", height: double.infinity, width: 200, fit: BoxFit.fitHeight);
                }
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                    ),
                  ),
                  Text(
                    book.genre,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownMenu<int>(
                          width: 100,
                          initialSelection: book.rating,
                          onSelected: (int? value) {
                            FirebaseDatabase.instance.ref().child("books/reading/${book.id}").set(
                              {
                                "title" : book.title,
                                "author" : book.author,
                                "genre" : book.genre,
                                "rating" : value!,
                                "isFinished" : book.isFinished,
                                "imageLink" : book.imageLink
                              }
                            );
                          },
                          dropdownMenuEntries: rating.map<DropdownMenuEntry<int>>((int rating) {
                            return DropdownMenuEntry(value: rating, label: rating.toString());
                          }).toList(),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.star)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FirebaseDatabase.instance.ref().child(book.isFinished ? "books/finished/${book.id}" : "books/reading/${book.id}").remove();
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Close"),
                                            )
                                          ],
                                          content: Text("${book.title} has been removed."),
                                        )
                                      );
                                    },
                                    child: const Text("Ok"),
                                  ),
                                ],
                                title: Text(book.title),
                                content: const Text("Are you sure you want to remove this book?"),
                              )
                            );
                          },
                          icon: const Icon(Icons.delete_forever),
                        ),
                        book.isFinished
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Close"),
                                      )
                                    ],
                                    content: Text("${book.title} has moved to Currently Reading"),
                                  )
                              );
                              FirebaseDatabase.instance.ref().child("books/reading/${book.id}").set(
                                  {
                                    "title" : book.title,
                                    "author" : book.author,
                                    "genre" : book.genre,
                                    "rating" : book.rating,
                                    "isFinished" : false,
                                    "imageLink" : book.imageLink
                                  }
                              );

                              FirebaseDatabase.instance.ref().child("books/finished/${book.id}").remove();
                            },
                            icon: const Icon(Icons.library_add_check),
                          )
                        : IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Close"),
                                    )
                                  ],
                                  content: Text("${book.title} has moved to Finished"),
                                )
                            );
                            FirebaseDatabase.instance.ref().child("books/finished/${book.id}").set(
                              {
                                "title" : book.title,
                                "author" : book.author,
                                "genre" : book.genre,
                                "rating" : book.rating,
                                "isFinished" : true,
                                "imageLink" : book.imageLink
                              }
                            );

                            FirebaseDatabase.instance.ref().child("books/reading/${book.id}").remove();
                          },
                          icon: const Icon(Icons.library_add_outlined),
                        )
                      ]
                    )
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}

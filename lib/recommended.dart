import 'package:bootstrap/book.dart';
import 'package:bootstrap/navbar%20helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Book b = Book(
    id: "1",
    title: "One Piece",
    author: "Eiichiro Oda",
    genre: "Adventure Fantasy",
    rating: 10,
    isFinished: false,
    imageLink: "https://static.wikia.nocookie.net/onepiece/images/0/0e/Volume_1.png/revision/latest?cb=20220426144844"
);

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: const Text(
          "Recommended",
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
                Expanded(
                  flex: 13,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            b.title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                        Image.network(
                          b.imageLink,
                          height: 500,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              const Text(
                                "Author:",
                                style: TextStyle(
                                  fontSize: 24,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                b.author,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              const Text(
                                "Genre:",
                                style: TextStyle(
                                  fontSize: 24,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                b.genre,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                "Summary:",
                                style: TextStyle(
                                  fontSize: 24,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "The story follows the adventures of Monkey D. Luffy and his crew, the Straw Hat Pirates, where he explores the Grand Line in search of the mythical treasure known as the \"One Piece\" in order to become the next King of the Pirates.",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print(b.title);
                            print(b.author);
                            print(b.genre);
                            print(b.rating);
                            print(b.isFinished);
                            print(b.imageLink);

                            FirebaseDatabase.instance.ref().child("books/reading/book${b.id}").set(
                                {
                                  "title" : b.title,
                                  "author" : b.author,
                                  "genre" : b.genre,
                                  "rating" : b.rating,
                                  "isFinished" : b.isFinished,
                                  "imageLink" : b.imageLink
                                }
                            ).then((value) => {
                              print("Successfully Added")
                            }).catchError((error) {
                              print("Failed to Add." + error.toString());
                            });
                          },
                          child: const Text("Add to Reading List"),
                        )
                      ],
                    ),
                  ),
                ),
                const NavBarHelper()
              ],
            ),
          )
      ),
    );
  }
}


import 'package:bootstrap/navbar%20helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const List<int> rating = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPage();
}

class _AddBookPage extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  int ratingValue = rating.first;
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Add Book",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.grey,
        ),
        body: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  flex: 14,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Title",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: "Title",
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 15),

                          Column(
                            children: [
                              const Text(
                                "Author",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              TextField(
                                controller: authorController,
                                decoration: const InputDecoration(
                                    hintText: "Author",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 15),

                          Column(
                            children: [
                              const Text(
                                "Genre",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              TextField(
                                controller: genreController,
                                decoration: const InputDecoration(
                                    hintText: "Genre",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [

                                  const Text(
                                    "Rating",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: DropdownMenu<int>(
                                      initialSelection: ratingValue,
                                      onSelected: (int? value) {
                                        setState(() {
                                          ratingValue = value!;
                                        });
                                      },
                                      dropdownMenuEntries: rating.map<DropdownMenuEntry<int>>((int rating) {
                                        return DropdownMenuEntry(value: rating, label: rating.toString());
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),

                              Column(
                                children: [
                                  const Text(
                                    "Finished",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      activeColor: Colors.black,
                                      value: isFinished,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isFinished = value!;
                                        });
                                      },
                                    )
                                  )
                                ],
                              )
                            ],
                          ),

                          const SizedBox(height: 15),

                          Column(
                            children: [
                              const Text(
                                "Image Link (.png or .jpg) (optional)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              TextField(
                                controller: imageController,
                                decoration: const InputDecoration(
                                    hintText: "Image Link",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                              print(titleController.text);
                              print(authorController.text);
                              print(genreController.text);
                              print(ratingValue);
                              print(isFinished);
                              print(imageController.text);

                              if(imageController.text.contains(".jpg") || imageController.text.contains(".png")) {
                                var timestamp = DateTime.now().microsecondsSinceEpoch;
                                FirebaseDatabase.instance.ref().child(isFinished ? "books/finished/book$timestamp" : "books/reading/book$timestamp").set(
                                    {
                                      "title" : titleController.text,
                                      "author" : authorController.text,
                                      "genre" : genreController.text,
                                      "rating" : ratingValue,
                                      "isFinished" : isFinished,
                                      "imageLink" : imageController.text
                                    }
                                ).then((value) => {
                                  print("Successfully Added")
                                }).catchError((error) {
                                  print("Failed to Add. $error");
                                });
                              }
                              else {
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
                                      title: Text("Invalid Link"),
                                      content: Text("Link must contain a png or jpg file."),
                                    )
                                );
                              }
                            },
                            child: const Text("Submit"),
                          )
                        ],
                      ),
                    )
                  )
                ),
                const NavBarHelper()
              ],
            ),
          )
        )
    );
  }
}

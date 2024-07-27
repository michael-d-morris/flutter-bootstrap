import 'package:bootstrap/add_book.dart';
import 'package:bootstrap/finished_list.dart';
import 'package:bootstrap/reading_list.dart';
import 'package:bootstrap/recommended.dart';
import 'package:flutter/material.dart';

class NavBarHelper extends StatelessWidget {
  const NavBarHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.grey,
            border: Border(top: BorderSide())
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                print("reading");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReadingListPage())
                );
              },
              icon: const Icon(Icons.menu_book),
            ),
            IconButton(
              onPressed: () {
                print("add");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddBookPage())
                );
              },
              icon: const Icon(Icons.add_circle),
            ),
            IconButton(
              onPressed: () {
                print("finished");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FinishedListPage())
                );
              },
              icon: const Icon(Icons.library_books),
            ),
            IconButton(
              onPressed: () {
                print("recommend");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommendedPage())
                );
              },
              icon: const Icon(Icons.recommend),
            ),
          ],
        ),
      ),
    );
  }
}

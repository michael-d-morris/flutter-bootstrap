import 'package:bootstrap/firebase_options.dart';
import 'package:bootstrap/reading_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Book List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    "assets/book.png",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontFamily: "Georgia"
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                    )
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Georgia"
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontFamily: "Georgia"
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                      )
                  ),
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Georgia"
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text
                    ).then((value) {
                      print("Successful Login");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReadingListPage())
                      );
                    }).catchError((error) {
                      print("Failed Login");
                      print(error);
                    });
                  },
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    ).then((value) {
                      print("Successful Sign Up");
                    }).catchError((error) {
                      print(error.toString());
                    });
                  },
                  child: const Text("Sign Up"),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

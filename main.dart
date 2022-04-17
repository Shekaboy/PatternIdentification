import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/ForgotPasswordPage.dart';
import 'package:myapp/RegisterPage.dart';
import 'package:myapp/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "XXXX", // Your apiKey
      appId: "XXXX", // Your appId
      messagingSenderId: "XXXX", // Your messagingSenderId
      projectId: "XXXX", // Your projectId
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Firebase stuff

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProfileScreen();
            } else {
              return LoginScreen();
            }
          }),
    );
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Database Error Try again Later")));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Firebase Login Function
  static Future<User?> loginUsingEmainPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No User found for that email")));
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Login to your account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.mail, color: Colors.black)),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.black)),
                ),
                GestureDetector(
                  child: const Text(
                    "Forgot password ?",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.left,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  child: const Text(
                    "New User ? Register?",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.left,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    onPressed: () async {
                      //User Presses the Login Button
                      User? user = await loginUsingEmainPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                      if (user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                      }
                    },
                    child: const Text("Login",
                        style: TextStyle(color: Colors.white)),
                    fillColor: Colors.blue,
                    elevation: 20,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            )));
  }
}

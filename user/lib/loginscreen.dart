import 'package:flutter/material.dart';
import 'package:user/category.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void showLoginMessage(String message, Color color, BuildContext scaffoldContext) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            return Container(
             
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'images/logo2.png',
                          width: 150.0,
                          height: 150.0,
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Container(
                                height: 43,
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email or Username',
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Neutraface'),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                height: 43,
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Neutraface'),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:Colors.red , width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 80.0),
                        SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            print('Login button tapped');
                            loginUser(scaffoldContext);
                          },
                          child: Container(
                            height: 50,
                            width: 400,
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Neutraface'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void loginUser(BuildContext scaffoldContext) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showLoginMessage('Please enter both email/username and password.', Colors.red, scaffoldContext);
      return;
    }

    // Hardcoded email and password for demonstration purposes
    if (emailController.text != 'admin123@gmail.com' || passwordController.text != '123456') {
      showLoginMessage('Invalid email or password.', Colors.red, scaffoldContext);
      return;
    }

    // Use the current context to show the SnackBar
    showLoginMessage('Login successful!', Colors.green, scaffoldContext);

    // Navigate to the next screen (replace this with your actual logic)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryScreen())
    );
  }
}

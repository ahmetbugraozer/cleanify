import 'package:cleanify/elements/project_elements.dart';
import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/pages/signupeditprofile.dart';
import 'package:cleanify/pages/tabbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password2 = TextEditingController();
  bool isError = false;
  String? usernameErrorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  bool isEmailTextFieldError = false;
  bool isUsernameTextFieldError = false;
  bool isPasswordTextFieldError = false;
  Future<void> signUp(String email, String password, String username) async {
    await Auth().signUp(email: email, password: password, username: username);
  }

  Future<void> login(String email, String password) async {
    await Auth()
        .signIn(email: email, password: password)
        .catchError((error) => isError = true);
  }

  bool pageState = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppbar(preference: "main"),
        backgroundColor: ProjectColors.projectBackgroundColor,
        body: SingleChildScrollView(
            child: pageState
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'E-mail',
                                  labelText: "Enter your e-mail",
                                  border: OutlineInputBorder())),
                          const SizedBox(height: 20),
                          TextField(
                              controller: password,
                              maxLength: 20,
                              maxLines: 1,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter your password',
                                  labelText: "Password",
                                  border: OutlineInputBorder())),
                          Padding(
                            padding: const EdgeInsets.only(left: 185),
                            child: TextButton(
                                onPressed: () {},
                                child: const Text("Forgot password?",
                                    style: ProjectTextStyles
                                        .styleListViewGeneral)),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                login(email.text, password.text).then((value) {
                                  if (isError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Email or password is not correct. Please try again.")));
                                    isError = false;
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const MainTabBar();
                                    }));
                                  }
                                });
                              },
                              child: const Text('Login',
                                  style:
                                      ProjectTextStyles.styleListViewGeneral)),
                          const SizedBox(height: 20),
                          const Row(children: [
                            Expanded(child: Divider(thickness: 2)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Center(
                                    child: Text("Or",
                                        style: TextStyle(fontSize: 20)))),
                            Expanded(child: Divider(thickness: 2))
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 30),
                                    child: MaterialButton(
                                        onPressed: () {},
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                                child: Image.asset(
                                                    "assets/google.png",
                                                    fit: BoxFit.contain,
                                                    width: 70))))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 30),
                                    child: MaterialButton(
                                        onPressed: () {},
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                                child: Image.asset(
                                                    "assets/facebook.png",
                                                    fit: BoxFit.contain,
                                                    width: 50,
                                                    height: 50)))))
                              ]),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        pageState = !pageState;
                                        debugPrint(pageState.toString());
                                      });
                                    },
                                    child: const Text('Sign Up',
                                        style: ProjectTextStyles
                                            .styleListViewGeneral))
                              ])
                        ]))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Create an Account',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onChanged: _validateEmailTextField,
                              decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "E-mail",
                                  hintText: 'Enter your e-mail',
                                  errorText: isEmailTextFieldError
                                      ? emailErrorMessage
                                      : null,
                                  border: const OutlineInputBorder())),
                          const SizedBox(height: 20),
                          TextField(
                            controller: username,
                            maxLines: 1,
                            onChanged: _validateUsernameTextField,
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Username",
                                hintText: 'Enter your username',
                                errorText: isUsernameTextFieldError
                                    ? usernameErrorMessage
                                    : null,
                                border: const OutlineInputBorder()),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                              controller: password,
                              maxLength: 20,
                              maxLines: 1,
                              obscureText: true,
                              onChanged: _validatePasswordTextFields,
                              decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Password",
                                  hintText: 'Enter your password',
                                  errorText: isPasswordTextFieldError
                                      ? passwordErrorMessage
                                      : null,
                                  border: const OutlineInputBorder())),
                          const SizedBox(height: 20),
                          TextField(
                              controller: password2,
                              maxLength: 20,
                              maxLines: 1,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  labelText: "Confirm Password",
                                  hintText: 'Confirm your password',
                                  border: OutlineInputBorder())),
                          const SizedBox(height: 5),
                          ElevatedButton(
                              onPressed: () {
                                if (!isEmailTextFieldError &&
                                    !isUsernameTextFieldError &&
                                    !isPasswordTextFieldError) {
                                  if (password.text == password2.text) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const SignUpEditProfile();
                                    }));

                                    signUp(email.text, password.text,
                                        username.text);
                                    setState(() {
                                      pageState = !pageState;
                                      email.clear();
                                      password.clear();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Passwords are not same. Please try again.")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Something went wrong. Please try again.")));
                                }
                              },
                              child: const Text('Sign Up',
                                  style:
                                      ProjectTextStyles.styleListViewGeneral)),
                          const SizedBox(height: 10),
                          const Row(children: [
                            Expanded(child: Divider(thickness: 2)),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Center(
                                    child: Text("Or",
                                        style: TextStyle(fontSize: 20)))),
                            Expanded(child: Divider(thickness: 2))
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 25),
                                    child: MaterialButton(
                                        onPressed: () {},
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                                child: Image.asset(
                                                    "assets/google.png",
                                                    fit: BoxFit.contain,
                                                    width: 70))))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 25),
                                    child: MaterialButton(
                                        onPressed: () {},
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                                child: Image.asset(
                                                    "assets/facebook.png",
                                                    fit: BoxFit.contain,
                                                    width: 50,
                                                    height: 50)))))
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        pageState = !pageState;
                                        debugPrint(pageState.toString());
                                      });
                                    },
                                    child: const Text('Login',
                                        style: ProjectTextStyles
                                            .styleListViewGeneral))
                              ])
                        ]))));
  }

  void _validateEmailTextField(String value) {
    setState(() {
      if (value.isEmpty) {
        emailErrorMessage = 'This field cannot be empty';
        isEmailTextFieldError = true;
      } else {
        isEmailTextFieldError = false;
      }
    });
  }

  void _validateUsernameTextField(String value) {
    setState(() {
      if (value.isEmpty) {
        usernameErrorMessage = 'This field cannot be empty';
        isUsernameTextFieldError = true;
      } else {
        isUsernameTextFieldError = false;
      }
    });
  }

  void _validatePasswordTextFields(String value) {
    setState(() {
      if (value.isEmpty) {
        passwordErrorMessage = "This field cannot be empty";
        isPasswordTextFieldError = true;
      } else if (value.length < 5) {
        passwordErrorMessage = "Password must be more than 5 characters";
        isPasswordTextFieldError = true;
      } else {
        isPasswordTextFieldError = false;
      }
    });
  }
}

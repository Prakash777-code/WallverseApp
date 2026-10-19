import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/screens/login_screen.dart';
import 'package:wallverse/utils/helper.dart';
import 'package:wallverse/viewModels/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final authViewModel = AuthViewmodel();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final helper = Helper();

  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF241039),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Wallverse',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'cursive',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Sign up to see photos and videos from your friends.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
                          hintText: 'Name',
                          filled: true,
                          fillColor: const Color(0xFF321A4D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
                          hintText: 'Email',
                          filled: true,
                          fillColor: const Color(0xFF321A4D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }

                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
                          hintText: 'Password',
                          filled: true,
                          fillColor: const Color(0xFF321A4D),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          final res = helper.checkPassword(value!);
                          if (res != "Strong password") {
                            return res;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: authViewModel.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    await authViewModel.register(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );

                                    if (authViewModel.errorMessage == null) {
                                      Fluttertoast.showToast(msg: "Registered");
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const LoginScreen();
                                          },
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: authViewModel.errorMessage!,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA855F7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: authViewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Color(0xFFDBDBDB)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Color(0xFFDBDBDB)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginScreen();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: const Color(0xFFA855F7),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _login() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF091a47), Color(0xFF081F5D)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 350,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 84),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: const Border(
                        top: BorderSide(color: Color(0xFFb40404), width: 6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(128),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('USERNAME',
                          style: TextStyle(
                            color: Color(0x990F1A3B),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _usernameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            filled: true,
                            fillColor: const Color(0x30000000),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'PASSWORD',
                          style: TextStyle(
                            color: Color(0x990F1A3B),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            filled: true,
                            fillColor: const Color(0x30000000),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white70, thickness: 2),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFad0808),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF091a47),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'images/mccLogo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => const Icon(
                            Icons.school,
                            size: 1000000,
                            color: Color(0xFF030357),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}

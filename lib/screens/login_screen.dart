import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../firebase/auth.dart';
import '../widgets/loading_modal_widget.dart';
import '../widgets/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Auth _auth = Auth();

  bool isLoading = false;

  final padding = 16.0;
  final spacer = const SizedBox(height: 16.0);

  // TextField controllers
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget logoItc() => Padding(
        padding: EdgeInsets.all(padding * 2),
        child: Image.asset('assets/logo.png', height: 120.0),
      );

  Widget loginForm() => Column(
        children: [
          spacer,
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Text(
              'Iniciar sesión',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            margin: EdgeInsets.all(padding),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo electrónico',
                      hintText: 'test@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  spacer,
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                    ),
                  ),
                  spacer,
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.generalLogin,
                    text: 'Iniciar sesión',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () => onLoginClicked(context),
                  ),
                  spacer,
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('Crear cuenta'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  void onLoginClicked(BuildContext context) {
    _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((success) {
      setState(() {
        isLoading = false;
      });
      // TODO: checar si el resultado es true
      Navigator.of(context).pushReplacementNamed('/dash');
    });
  }

  void onGoogleLoginClicked(BuildContext context) {
    _auth.signInWithGoogle().then((success) {
      setState(() {
        isLoading = false;
      });
      if (success) {
        Navigator.of(context).pushReplacementNamed('/dash');
      }
    });
  }

  void onGithubLoginClicked(BuildContext context) {
    _auth.signInWithGithub().then((success) {
      setState(() {
        isLoading = false;
      });
      if (success) {
        Navigator.of(context).pushReplacementNamed('/dash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Responsive(
                mobile: Column(
                  children: [logoItc(), loginForm()],
                ),
                desktop: Row(
                  children: [
                    Expanded(child: logoItc()),
                    Expanded(child: loginForm()),
                  ],
                ),
              ),
            ),
          ),
          isLoading ? const LoadingModal() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

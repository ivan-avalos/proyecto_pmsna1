import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../firebase/auth.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/loading_modal_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  final padding = 16.0;
  final spacer = const SizedBox(height: 16.0);

  XFile? _avatar;

  // TextField controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  bool validateForm() {
    if (_formKey.currentState!.validate() && _avatar != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Crear cuenta'),
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      spacer,
                      Card(
                        margin:
                            EdgeInsets.fromLTRB(padding, 0, padding, padding),
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AvatarPicker(
                                  avatar: _avatar,
                                  onAvatarPicked: (avatar) {
                                    setState(() {
                                      _avatar = avatar;
                                    });
                                  },
                                ),
                                spacer,
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nombre',
                                    hintText: 'Juan Pérez',
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El nombre no debe estar vacío';
                                    }
                                    return null;
                                  },
                                ),
                                spacer,
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Correo electrónico',
                                    hintText: 'test@example.com',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El correo no debe estar vacío';
                                    } else if (!EmailValidator.validate(
                                        value)) {
                                      return 'El formato del correo es inválido';
                                    }
                                    return null;
                                  },
                                ),
                                spacer,
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Contraseña',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La contraseña no debe estar vacía';
                                    }
                                    return null;
                                  },
                                ),
                                spacer,
                                SocialLoginButton(
                                  buttonType:
                                      SocialLoginButtonType.generalLogin,
                                  text: 'Crear cuenta',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  onPressed: () => onRegisterClicked(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading ? const LoadingModal() : const SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onRegisterClicked(BuildContext context) {
    setState(() {
      isLoading = false;
      if (validateForm()) {
        Auth()
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
          avatar: File(_avatar!.path),
        )
            .then((success) {
          if (success) {
            Navigator.of(context).pushNamed('/onboard');
          }
        });
      }
    });
  }
}
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
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<XFile?> _avatarNotifier = ValueNotifier<XFile?>(null);

  final padding = 16.0;
  final spacer = const SizedBox(height: 16.0);

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
    if (_formKey.currentState!.validate() && _avatarNotifier.value != null) {
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
                                ValueListenableBuilder(
                                  valueListenable: _avatarNotifier,
                                  builder: (context, value, child) =>
                                      AvatarPicker(
                                    avatar: _avatarNotifier.value,
                                    onAvatarPicked: (avatar) {
                                      _avatarNotifier.value = avatar;
                                    },
                                  ),
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
                ValueListenableBuilder(
                  valueListenable: _loadingNotifier,
                  builder: (context, value, child) =>
                      value ? const LoadingModal() : const SizedBox.shrink(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onRegisterClicked(BuildContext context) {
    _loadingNotifier.value = true;
    if (validateForm()) {
      Auth()
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _nameController.text,
        avatar: File(_avatarNotifier.value!.path),
      )
          .then((result) {
        _loadingNotifier.value = false;
        result.fold((user) {
          Navigator.of(context).pushReplacementNamed('/login');
        }, (error) {
          String message;
          switch (error.code) {
            case 'email-already-in-use':
              message = 'El correo electrónico ya se encuentra en uso';
            case 'invalid-email':
              message = 'El correo electrónico es inválido';
            case 'operation-not-allowed':
              message = 'La operación no está permitida';
            case 'weak-password':
              message = 'La contraseña es muy débil';
            default:
              message = 'Ocurrió un error desconocido';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        });
      });
    }
  }
}

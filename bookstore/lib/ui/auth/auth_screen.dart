import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/request_auth_model.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/password_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:bookstore/ui/auth/bloc/auth_events.dart';
import 'package:bookstore/ui/auth/bloc/auth_states.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final GlobalKey _formKey = GlobalKey<FormState>();

  final RequestAuthModel authModel = RequestAuthModel.empty();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is AuthenticateErrorState) {
          showCustomDialog(context, "Login falhou");
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 64,
                    children: [
                      Image.asset(
                        "assets/logo_text.png",
                        width: 179,
                        height: 134,
                      ),
                      Column(
                        spacing: 16,
                        children: [
                          TextFieldWidget(
                            hint: "user",
                            onChanged: (value) {
                              authModel.user = value;
                            },
                          ),
                          PasswordFielWidget(
                            onChanged: (value) {
                              authModel.password = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      LoadingButtonWidget(
                        isLoading: state is LoadingState,
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            BlocProvider.of<AuthBloc>(
                              context,
                            ).add(AuthenticateEvent(authModel: authModel));
                          }
                        },
                        child: Text("Entrar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Text("Cadastre sua loja"),
                      ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/request_register_model.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:mybookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:mybookstore/ui/_core/widgets/password_field_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/bloc/auth_events.dart';
import 'package:mybookstore/ui/auth/bloc/auth_states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RequestRegisterModel storeModel = RequestRegisterModel.empty();

  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is RegisterErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Cadastro falhou")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context: context, title: "Cadastrar loja"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Image.asset(
                      "assets/logo_purple_text.png",
                      width: 179,
                      height: 134,
                    ),
                    TextFieldWidget(
                      hint: "Nome da loja",
                      onChanged: (value) {
                        storeModel.name = value;
                      },
                    ),
                    TextFieldWidget(
                      hint: "Slogan da loja",
                      onChanged: (value) {
                        storeModel.slogan = value;
                      },
                    ),
                    ImageFieldWidget(
                      hint: "Banner da loja",
                      onChanged: ({required String imageBase64}) {
                        storeModel.banner = imageBase64;
                      },
                    ),
                    TextFieldWidget(
                      hint: "Nome do administrador",
                      onChanged: (value) {
                        storeModel.admin.name = value;
                      },
                    ),
                    TextFieldWidget(
                      hint: "User do administrador",
                      onChanged: (value) {
                        storeModel.admin.username = value;
                      },
                    ),
                    ImageFieldWidget(
                      hint: "Foto do administrador",
                      onChanged: ({required String imageBase64}) {
                        storeModel.admin.photo = imageBase64;
                      },
                    ),
                    PasswordFielWidget(
                      onChanged: (value) {
                        storeModel.admin.password = value;
                      },
                    ),
                    PasswordFielWidget(
                      hint: "Repetir senha",
                      validator: (value) {
                        if (value != storeModel.admin.password) {
                          return "As senhas não conferem";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                    LoadingButtonWidget(
                      isLoading: state is LoadingState,
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          BlocProvider.of<AuthBloc>(
                            context,
                          ).add(RegisterEvent(requestStoreModel: storeModel));
                        }
                      },
                      child: Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

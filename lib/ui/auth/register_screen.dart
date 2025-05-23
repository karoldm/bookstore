import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/request_register_model.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/password_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:bookstore/ui/auth/bloc/auth_events.dart';
import 'package:bookstore/ui/auth/bloc/auth_states.dart';
import 'package:image_picker/image_picker.dart';

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
          showCustomDialog(context, "Cadastro falhou: ${state.message}");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context: context, title: "Cadastrar loja"),
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
                    spacing: 32,
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
                            onChanged: ({required XFile? imageData}) {
                              storeModel.banner = imageData;
                            },
                          ),
                          TextFieldWidget(
                            hint: "Nome do administrador",
                            onChanged: (value) {
                              storeModel.adminName = value;
                            },
                          ),
                          TextFieldWidget(
                            hint: "User do administrador",
                            onChanged: (value) {
                              storeModel.username = value;
                            },
                          ),
                          PasswordFielWidget(
                            onChanged: (value) {
                              storeModel.password = value;
                            },
                          ),
                          PasswordFielWidget(
                            hint: "Repetir senha",
                            validator: (value) {
                              if (value != storeModel.password) {
                                return "As senhas não conferem";
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ],
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
          ),
        );
      },
    );
  }
}

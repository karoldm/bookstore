import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/data/models/user_model.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_events.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:mybookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';

class EditStoreScreen extends StatefulWidget {
  final RequestStoreModel initialStoreModel;
  final UserModel user;

  const EditStoreScreen({
    required this.initialStoreModel,
    super.key,
    required this.user,
  });

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  late RequestStoreModel storeModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    storeModel = widget.initialStoreModel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreStates>(
      listenWhen:
          (context, state) =>
              state is UpdateStoreErrorState ||
              state is StoreUpdateSuccessState,
      listener: (context, state) {
        if (state is UpdateStoreErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erro ao atualizar loja")));
        } else if (state is StoreUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Loja atualizada com sucesso!")),
          );
          context.read<StoreBloc>().add(LoadStoreEvent(store: state.store));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context: context, title: "Editar loja "),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                spacing: 24,
                children: [
                  CircleAvatarWidget(
                    image: widget.user.photo,
                    name: widget.user.name,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 16,
                      children: [
                        TextFieldWidget(
                          hint: "Nome da loja",
                          initialValue: storeModel.name,
                          onChanged: (value) {
                            storeModel.name = value;
                          },
                        ),
                        TextFieldWidget(
                          hint: "Slogan",
                          initialValue: storeModel.slogan,
                          onChanged: (value) {
                            storeModel.slogan = value;
                          },
                        ),
                        ImageFieldWidget(
                          hint: "Banner",
                          initialValue: storeModel.banner,
                          onChanged: ({required String imageBase64}) {
                            storeModel.banner = imageBase64;
                          },
                        ),
                      ],
                    ),
                  ),
                  LoadingButtonWidget(
                    isLoading: state is StoreUpdatingState,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<StoreBloc>().add(
                          UpdateStoreEvent(storeModel: storeModel),
                        );
                      }
                    },
                    child: Text("Salvar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

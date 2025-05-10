import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/request_store_model.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_events.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditStoreScreen extends StatefulWidget {
  final StoreModel initialStoreModel;

  const EditStoreScreen({required this.initialStoreModel, super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  late RequestStoreModel storeModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    storeModel = RequestStoreModel.fromEmpty();
    storeModel.name = widget.initialStoreModel.name;
    storeModel.slogan = widget.initialStoreModel.slogan;
    storeModel.id = widget.initialStoreModel.id;
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
          showCustomDialog(context, "Erro ao atualizar loja");
        } else if (state is StoreUpdateSuccessState) {
          showCustomDialog(context, "Loja atualizada com sucesso!");
          context.read<StoreBloc>().add(LoadStoreEvent(store: state.store));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context: context, title: "Editar loja "),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 32,
                      children: [
                        Column(
                          spacing: 24,
                          children: [
                            Image.asset(
                              "assets/logo_text.png",
                              width: 179,
                              height: 134,
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
                                    canDelete: false,
                                    initialImageUrl:
                                        widget.initialStoreModel.banner,
                                    hint: "Banner",
                                    onChanged: ({required XFile? imageData}) {
                                      storeModel.banner = imageData;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
          ),
        );
      },
    );
  }
}

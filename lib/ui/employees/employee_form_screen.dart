import 'package:bookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/create_employee_model.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/password_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/employees/bloc/employees_bloc.dart';
import 'package:bookstore/ui/employees/bloc/employees_events.dart';
import 'package:bookstore/ui/employees/bloc/employees_states.dart';

class EmployeeFormScreen extends StatefulWidget {
  final int storeId;

  const EmployeeFormScreen({super.key, required this.storeId});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final CreateEmployeeModel employee = CreateEmployeeModel.empty();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesBloc, EmployeesStates>(
      listenWhen:
          (previous, current) =>
              current is AddEmployeeSuccessState ||
              current is AddEmployeeErrorState,
      listener: (context, state) {
        if (state is AddEmployeeSuccessState) {
          showCustomDialog(context, "Funcionário adicionado com sucesso!");
          BlocProvider.of<EmployeesBloc>(
            context,
          ).add(FetchEmployeesEvent(storeId: widget.storeId));
          Navigator.pop(context);
        } else if (state is AddEmployeeErrorState) {
          showCustomDialog(
            context,
            "Erro ao adicionar funcionário: ${state.message}",
          );
        }
      },
      builder:
          (context, state) => Scaffold(
            appBar: appBarWidget(title: "Novo Funcionário", context: context),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 32,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 16,
                              children: [
                                CircleAvatarWidget(name: employee.name),
                                TextFieldWidget(
                                  initialValue: employee.name,
                                  hint: "Nome do Funcionário",
                                  onChanged: (value) {
                                    setState(() {
                                      employee.name = value;
                                    });
                                  },
                                ),

                                TextFieldWidget(
                                  initialValue: employee.username,
                                  hint: "Username do Funcionário",
                                  onChanged: (value) {
                                    employee.username = value;
                                  },
                                ),
                                PasswordFielWidget(
                                  onChanged: (value) {
                                    employee.password = value;
                                  },
                                ),
                                PasswordFielWidget(
                                  hint: "Repetir senha",
                                  validator: (value) {
                                    if (value != employee.password) {
                                      return "As senhas não conferem";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                ),
                              ],
                            ),

                            LoadingButtonWidget(
                              isLoading: state is EmployeesLoadingState,
                              child: Text("Salvar"),
                              onPressed: () {
                                if ((_formKey.currentState as FormState)
                                    .validate()) {
                                  BlocProvider.of<EmployeesBloc>(context).add(
                                    AddEmployeeEvent(
                                      storeId: widget.storeId,
                                      employee: employee,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}

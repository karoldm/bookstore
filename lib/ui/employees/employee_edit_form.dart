import 'package:bookstore/data/models/edit_employee_model.dart';
import 'package:bookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/password_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/employees/bloc/employees_bloc.dart';
import 'package:bookstore/ui/employees/bloc/employees_events.dart';
import 'package:bookstore/ui/employees/bloc/employees_states.dart';

class EmployeeEditScreen extends StatefulWidget {
  final EmployeeModel initialEmployee;
  final int storeId;

  const EmployeeEditScreen({
    super.key,
    required this.initialEmployee,
    required this.storeId,
  });

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  final EditEmployeeModel employee = EditEmployeeModel.empty();

  final _formKey = GlobalKey<FormState>();

  bool _editPassword = true;

  @override
  void initState() {
    super.initState();
    employee.name = widget.initialEmployee.name;
    _editPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesBloc, EmployeesStates>(
      listenWhen:
          (previous, current) =>
              current is UpdatedEmployeeSuccessState ||
              current is UpdateEmployeeErrorState,
      listener: (context, state) {
        if (state is UpdatedEmployeeSuccessState) {
          showCustomDialog(context, "Funcionário atualizado com sucesso!");
          BlocProvider.of<EmployeesBloc>(
            context,
          ).add(FetchEmployeesEvent(storeId: widget.storeId));
          Navigator.pop(context);
        } else if (state is UpdateEmployeeErrorState) {
          showCustomDialog(
            context,
            "Erro ao atualizar funcionário: ${state.message}",
          );
        }
      },
      builder:
          (context, state) => Scaffold(
            appBar: appBarWidget(title: "Editar Funcionário", context: context),
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

                                if (_editPassword) ...[
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
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _editPassword = false;
                                      });
                                    },
                                    child: Text("Cancelar"),
                                  ),
                                ],
                                if (!_editPassword)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _editPassword = true;
                                      });
                                    },
                                    child: Text("Alterar Senha"),
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
                                    UpdateEmployeeEvent(
                                      storeId: widget.storeId,
                                      employeeId: widget.initialEmployee.id,
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

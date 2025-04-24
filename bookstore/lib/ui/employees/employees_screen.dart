import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:bookstore/ui/_core/widgets/confirm_modal_widget.dart';
import 'package:bookstore/ui/employees/bloc/employees_bloc.dart';
import 'package:bookstore/ui/employees/bloc/employees_events.dart';
import 'package:bookstore/ui/employees/bloc/employees_states.dart';
import 'package:bookstore/ui/employees/employee_form_screen.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return BlocBuilder<EmployeesBloc, EmployeesStates>(
          builder:
              (context, emnployeeState) =>
                  emnployeeState is EmployeesLoadedState &&
                          storeState is StoreLoadedState
                      ? Column(
                        spacing: 32,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Funcionários", style: AppFonts.titleFont),
                          ListView.separated(
                            separatorBuilder:
                                (context, index) => SizedBox(height: 16),
                            shrinkWrap: true,
                            itemCount: emnployeeState.employees.length,
                            itemBuilder: (context, index) {
                              EmployeeModel employee =
                                  emnployeeState.employees[index];
                              return ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(
                                  employee.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => EmployeeFormScreen(
                                                  initialEmployee: employee,
                                                  storeId: storeState.store.id,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ConfirmModalWidget(
                                              label:
                                                  "Deseja remover o funcionário ${employee.name} ?",
                                              onConfirm: () {
                                                BlocProvider.of<EmployeesBloc>(
                                                  context,
                                                ).add(
                                                  DeleteEmployeeEvent(
                                                    storeId:
                                                        storeState.store.id,
                                                    employeeId: employee.id,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                leading: CircleAvatarWidget(
                                  radius: 32,
                                  image: employee.photo,
                                  name: employee.name,
                                ),
                                onTap: () {},
                              );
                            },
                          ),
                        ],
                      )
                      : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

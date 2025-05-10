import 'package:bookstore/data/models/employee_model.dart';

abstract class EmployeesStates {}

class EmployeesInitialEvent extends EmployeesStates {}

class EmployeesLoadingState extends EmployeesStates {}

class EmployeesLoadedState extends EmployeesStates {
  final List<EmployeeModel> employees;

  EmployeesLoadedState({required this.employees});
}

class LoadEmployeesErrorState extends EmployeesStates {
  final String message;

  LoadEmployeesErrorState({required this.message});
}

class UpdatedEmployeeSuccessState extends EmployeesStates {
  UpdatedEmployeeSuccessState();
}

class UpdateEmployeeErrorState extends EmployeesStates {
  final String message;

  UpdateEmployeeErrorState({required this.message});
}

class AddEmployeeSuccessState extends EmployeesStates {
  AddEmployeeSuccessState();
}

class AddEmployeeErrorState extends EmployeesStates {
  final String message;

  AddEmployeeErrorState({required this.message});
}

class DeleteEmployeeSuccessState extends EmployeesStates {
  DeleteEmployeeSuccessState();
}

class DeleteEmployeeErrorState extends EmployeesStates {
  final String message;

  DeleteEmployeeErrorState({required this.message});
}

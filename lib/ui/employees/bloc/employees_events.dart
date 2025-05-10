import 'package:bookstore/data/models/create_employee_model.dart';
import 'package:bookstore/data/models/edit_employee_model.dart';

abstract class EmployeesEvents {}

class FetchEmployeesEvent extends EmployeesEvents {
  final int storeId;

  FetchEmployeesEvent({required this.storeId});
}

class AddEmployeeEvent extends EmployeesEvents {
  final int storeId;
  final CreateEmployeeModel employee;

  AddEmployeeEvent({required this.storeId, required this.employee});
}

class UpdateEmployeeEvent extends EmployeesEvents {
  final int storeId;
  final int employeeId;
  final EditEmployeeModel employee;

  UpdateEmployeeEvent({
    required this.storeId,
    required this.employeeId,
    required this.employee,
  });
}

class DeleteEmployeeEvent extends EmployeesEvents {
  final int storeId;
  final int employeeId;

  DeleteEmployeeEvent({required this.storeId, required this.employeeId});
}

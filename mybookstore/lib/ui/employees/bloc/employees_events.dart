import 'package:mybookstore/data/models/request_employee_model.dart';

abstract class EmployeesEvents {}

class FetchEmployeesEvent extends EmployeesEvents {
  final int storeId;

  FetchEmployeesEvent({required this.storeId});
}

class AddEmployeeEvent extends EmployeesEvents {
  final int storeId;
  final RequestEmployeeModel employee;

  AddEmployeeEvent({required this.storeId, required this.employee});
}

class UpdateEmployeeEvent extends EmployeesEvents {
  final int storeId;
  final int employeeId;
  final RequestEmployeeModel employee;

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

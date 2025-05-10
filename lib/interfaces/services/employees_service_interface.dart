import 'package:bookstore/data/models/edit_employee_model.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/data/models/create_employee_model.dart';

abstract class EmployeesServiceInterface {
  Future<List<EmployeeModel>> fetchEmployees(int storeId);
  Future<void> updateEmployee(
    int storeId,
    int employeeId,
    EditEmployeeModel employee,
  );
  Future<void> addEmployee(int storeId, CreateEmployeeModel employee);
  Future<void> deleteEmployee(int storeId, int employeeId);
}

import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/data/models/request_employee_model.dart';

abstract class EmployeesServiceInterface {
  Future<List<EmployeeModel>> fetchEmployees(int storeId);
  Future<void> updateEmployee(
    int storeId,
    int employeeId,
    RequestEmployeeModel employee,
  );
  Future<void> addEmployee(int storeId, RequestEmployeeModel employee);
  Future<void> deleteEmployee(int storeId, int employeeId);
}

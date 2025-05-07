import 'package:bookstore/interfaces/services/employees_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/data/models/request_employee_model.dart';
import 'package:bookstore/interfaces/repositories/employees_repository_interface.dart';

class EmployeesRepository implements EmployeesRepositoryInterface {
  final EmployeesServiceInterface employeeService;

  EmployeesRepository(this.employeeService);

  @override
  Future<List<EmployeeModel>> fetchEmployees(int storeId) {
    try {
      return employeeService.fetchEmployees(storeId);
    } catch (e) {
      debugPrint('Failed to fetch employees on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateEmployee(
    int storeId,
    int employeeId,
    RequestEmployeeModel employee,
  ) async {
    try {
      await employeeService.updateEmployee(storeId, employeeId, employee);
    } catch (e) {
      debugPrint('Failed to update employee on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> addEmployee(int storeId, RequestEmployeeModel employee) async {
    try {
      await employeeService.addEmployee(storeId, employee);
    } catch (e) {
      debugPrint('Failed to add employee on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEmployee(int storeId, int employeeId) {
    try {
      return employeeService.deleteEmployee(storeId, employeeId);
    } catch (e) {
      debugPrint('Failed to delete employee on repository: $e');
      rethrow;
    }
  }
}

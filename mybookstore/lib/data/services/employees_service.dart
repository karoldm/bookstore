import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/employee_model.dart';
import 'package:mybookstore/data/models/request_employee_model.dart';
import 'package:mybookstore/interfaces/repositories/employees_repository__interface.dart';
import 'package:mybookstore/interfaces/services/employees_service_interface.dart';

class EmployeesService implements EmployeesServiceInterface {
  final EmployeesRepositoryInterface _repository;

  EmployeesService(this._repository);

  @override
  Future<List<EmployeeModel>> fetchEmployees(int storeId) {
    try {
      return _repository.fetchEmployees(storeId);
    } catch (e) {
      debugPrint('Failed to fetch employees on service: $e');
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
      await _repository.updateEmployee(storeId, employeeId, employee);
    } catch (e) {
      debugPrint('Failed to update employee on service: $e');
      rethrow;
    }
  }

  @override
  Future<void> addEmployee(int storeId, RequestEmployeeModel employee) async {
    try {
      await _repository.addEmployee(storeId, employee);
    } catch (e) {
      debugPrint('Failed to add employee on service: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEmployee(int storeId, int employeeId) {
    try {
      return _repository.deleteEmployee(storeId, employeeId);
    } catch (e) {
      debugPrint('Failed to delete employee on service: $e');
      rethrow;
    }
  }
}

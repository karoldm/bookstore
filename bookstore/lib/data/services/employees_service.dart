import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/data/models/request_employee_model.dart';
import 'package:bookstore/interfaces/services/employees_service_interface.dart';

class EmployeesService implements EmployeesServiceInterface {
  final Api clientApi = Api();

  @override
  Future<List<EmployeeModel>> fetchEmployees(int storeId) async {
    try {
      final response = await clientApi.api.get('/v1/store/$storeId/employee');
      final List<dynamic> data = response.data;
      return data.map((e) => EmployeeModel.fromMap(e)).toList();
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
      await clientApi.api.put(
        '/v1/store/$storeId/employee/$employeeId',
        data: jsonEncode(employee.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to update employee on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> addEmployee(int storeId, RequestEmployeeModel employee) async {
    try {
      await clientApi.api.post(
        '/v1/store/$storeId/employee',
        data: jsonEncode(employee.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to add employee on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEmployee(int storeId, int employeeId) async {
    try {
      await clientApi.api.delete('/v1/store/$storeId/employee/$employeeId');
    } catch (e) {
      debugPrint('Failed to delete employee on repository: $e');
      rethrow;
    }
  }
}

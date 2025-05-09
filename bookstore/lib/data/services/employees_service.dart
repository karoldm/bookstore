import 'dart:convert';

import 'package:bookstore/data/exceptions/custom_exception.dart';
import 'package:bookstore/data/models/edit_employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/data/models/employee_model.dart';
import 'package:bookstore/data/models/create_employee_model.dart';
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
      debugPrint('Failed to fetch employees in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<void> updateEmployee(
    int storeId,
    int employeeId,
    EditEmployeeModel employee,
  ) async {
    try {
      await clientApi.api.put(
        '/v1/store/$storeId/employee/$employeeId',
        data: jsonEncode(employee.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to update employee in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<void> addEmployee(int storeId, CreateEmployeeModel employee) async {
    try {
      await clientApi.api.post(
        '/v1/store/$storeId/employee',
        data: jsonEncode(employee.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to add employee in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<void> deleteEmployee(int storeId, int employeeId) async {
    try {
      await clientApi.api.delete('/v1/store/$storeId/employee/$employeeId');
    } catch (e) {
      debugPrint('Failed to delete employee in service: $e');
      throw CustomException(e.toString());
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/data/models/employee_model.dart';
import 'package:mybookstore/interfaces/services/employees_service_interface.dart';
import 'package:mybookstore/ui/employees/bloc/employees_events.dart';
import 'package:mybookstore/ui/employees/bloc/employees_states.dart';

class EmployeesBloc extends Bloc<EmployeesEvents, EmployeesStates> {
  final EmployeesServiceInterface _employeesService =
      GetIt.I<EmployeesServiceInterface>();

  final List<EmployeeModel> _employees = [];

  EmployeesBloc() : super(EmployeesInitialEvent()) {
    on<FetchEmployeesEvent>(_onLoadEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  void _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeesStates> emit,
  ) async {
    try {
      await _employeesService.updateEmployee(
        event.storeId,
        event.employeeId,
        event.employee,
      );

      emit(UpdatedEmployeeSuccessState());
    } catch (e) {
      emit(UpdateEmployeeErrorState(message: e.toString()));
    } finally {
      emit(EmployeesLoadedState(employees: _employees));
    }
  }

  void _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeesStates> emit,
  ) async {
    try {
      await _employeesService.deleteEmployee(event.storeId, event.employeeId);
      _employees.removeWhere((employee) => employee.id == event.employeeId);

      emit(DeleteEmployeeSuccessState());
    } catch (e) {
      emit(DeleteEmployeeErrorState(message: e.toString()));
    } finally {
      emit(EmployeesLoadedState(employees: _employees));
    }
  }

  void _onLoadEmployees(
    FetchEmployeesEvent event,
    Emitter<EmployeesStates> emit,
  ) async {
    emit(EmployeesLoadingState());
    try {
      final employees = await _employeesService.fetchEmployees(event.storeId);
      _employees.clear();
      _employees.addAll(employees);
    } catch (e) {
      emit(LoadEmployeesErrorState(message: e.toString()));
    } finally {
      emit(EmployeesLoadedState(employees: _employees));
    }
  }

  void _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeesStates> emit,
  ) async {
    try {
      await _employeesService.addEmployee(event.storeId, event.employee);

      emit(AddEmployeeSuccessState());
    } catch (e) {
      emit(AddEmployeeErrorState(message: e.toString()));
    } finally {
      emit(EmployeesLoadedState(employees: _employees));
    }
  }
}

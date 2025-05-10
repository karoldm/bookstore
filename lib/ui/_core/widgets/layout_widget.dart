import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/enums/role_enum.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/books/book_form_screen.dart';
import 'package:bookstore/ui/books/books_screen.dart';
import 'package:bookstore/ui/employees/employee_form_screen.dart';
import 'package:bookstore/ui/employees/employees_screen.dart';
import 'package:bookstore/ui/home/home_screen.dart';
import 'package:bookstore/ui/profile/profile_screen.dart';
import 'package:bookstore/ui/saved/saved_screen.dart';

class LayoutWidget extends StatefulWidget {
  const LayoutWidget({super.key});

  @override
  State<LayoutWidget> createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  int _currentIndex = 0;

  final List<Widget> _adminPages = [
    HomeScreen(),
    EmployeesScreen(),
    BooksScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _employeePages = [
    HomeScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      buildWhen: (previous, current) => current is StoreLoadedState,
      builder: (context, state) {
        if (state is StoreLoadedState) {
          final store = state.store;
          final isAdmin = store.user.role == Role.admin;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child:
                  isAdmin
                      ? _adminPages[_currentIndex]
                      : _employeePages[_currentIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                if (!isAdmin)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border_outlined),
                    label: 'Salvos',
                  ),
                if (isAdmin)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Funcionários',
                  ),
                if (isAdmin)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    label: 'Livros',
                  ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Meu perfil',
                ),
              ],
            ),
            floatingActionButton:
                (isAdmin && [1, 2].contains(_currentIndex))
                    ? FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        if (_currentIndex == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EmployeeFormScreen(
                                    storeId: state.store.id,
                                  ),
                            ),
                          );
                        } else if (_currentIndex == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      BookFormScreen(storeId: state.store.id),
                            ),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: AppColors.backgroundColor,
                      ),
                    )
                    : null,
          );
        }

        return Scaffold(body: const Center(child: CircularProgressIndicator()));
      },
    );
  }
}

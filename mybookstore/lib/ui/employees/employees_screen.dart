import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/user_model.dart';
import 'package:mybookstore/ui/_core/widgets/circular_avatar_widget.dart';

class EmployeesScreen extends StatelessWidget {
  final List<UserModel> employees = [
    UserModel(id: 1, name: "John Doe", photo: null),
    UserModel(id: 2, name: "Jane Smith", photo: null),
  ];

  EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Funcionários"),
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 16),
          shrinkWrap: true,
          itemCount: employees.length,
          itemBuilder: (context, index) {
            UserModel employee = employees[index];
            return ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(employee.name, overflow: TextOverflow.ellipsis),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete_outline),
                  ),
                ],
              ),
              leading: CircleAvatarWidget(
                radius: 32,
                image: employee.photo,
                name: employee.name,
              ),
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}

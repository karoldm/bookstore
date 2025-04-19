import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';

class FilterModalWidget extends StatelessWidget {
  const FilterModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 48,
        children: [
          Text("Filtrar"),
          Column(
            spacing: 16,
            children: [
              TextFieldWidget(hint: "Filtrar por título"),
              TextFieldWidget(hint: "Filtrar por autor"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              Text("Ano de publicação"),
              RangeSlider(
                onChanged: (value) {},
                values: RangeValues(0, 1),
                activeColor: AppColors.defaultColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Avaliação"), RatingBarWidget(rating: 0)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status"),
                  Switch(value: true, onChanged: (value) {}),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Filtrar"),
          ),
        ],
      ),
    );
  }
}

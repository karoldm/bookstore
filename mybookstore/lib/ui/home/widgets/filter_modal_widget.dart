import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';

class FilterModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onFilter;

  const FilterModalWidget({super.key, required this.onFilter});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  RangeValues _publicationYearRange = RangeValues(
    0,
    DateTime.now().year.toDouble(),
  );
  int? _rating;
  bool? _available;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 48,
          children: [
            Text(
              "Filtrar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              spacing: 16,
              children: [
                TextFieldWidget(
                  hint: "Filtrar por título",
                  controller: _titleController,
                ),
                TextFieldWidget(
                  hint: "Filtrar por autor",
                  controller: _authorController,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Text("Ano de publicação"),
                RangeSlider(
                  onChanged: (value) {
                    setState(() {
                      _publicationYearRange = value;
                    });
                  },
                  values: _publicationYearRange,
                  min: 0,
                  max: DateTime.now().year.toDouble(),
                  activeColor: AppColors.defaultColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Avaliação"),
                    RatingBarWidget(
                      rating: 0,
                      onRatingChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status"),
                    Switch(
                      value: _available ?? false,
                      onChanged: (value) {
                        setState(() {
                          _available = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> filtersMap = {
                  "year-start": _publicationYearRange.start.toInt(),
                  "year-finish": _publicationYearRange.end.toInt(),
                };

                if (_titleController.text.isNotEmpty) {
                  filtersMap["title"] = _titleController.text;
                }

                if (_authorController.text.isNotEmpty) {
                  filtersMap["author"] = _authorController.text;
                }

                if (_rating != null) {
                  filtersMap["rating"] = _rating;
                }

                if (_available != null) {
                  filtersMap["available"] = _available;
                }

                widget.onFilter(filtersMap);
                Navigator.pop(context);
              },
              child: Text("Filtrar"),
            ),

            TextButton(
              onPressed: () {
                widget.onFilter({});
                Navigator.pop(context);
              },
              child: Text("Limpar filtros"),
            ),
          ],
        ),
      ),
    );
  }
}

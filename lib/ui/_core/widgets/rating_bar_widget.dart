import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final bool? disabled;

  const RatingBarWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          InkWell(
            onTap: () {
              if (disabled == true) return;
              if (onRatingChanged != null) {
                onRatingChanged!(i);
              }
            },
            child: Icon(i <= rating ? Icons.star : Icons.star_border),
          ),
      ],
    );
  }
}

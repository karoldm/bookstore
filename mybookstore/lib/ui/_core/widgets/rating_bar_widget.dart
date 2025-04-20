import 'package:flutter/material.dart';

class RatingBarWidget extends StatefulWidget {
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
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          InkWell(
            onTap: () {
              if (widget.disabled == true) return;
              setState(() {
                _rating = i;
              });
              if (widget.onRatingChanged != null) {
                widget.onRatingChanged!(i);
              }
            },
            child: Icon(i <= _rating ? Icons.star : Icons.star_border),
          ),
      ],
    );
  }
}

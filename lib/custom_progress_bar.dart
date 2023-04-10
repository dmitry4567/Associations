import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double width;
  final int value;
  final int totalValue;
  final Color color;

  CustomProgressBar(
      {required this.width,
      required this.value,
      required this.totalValue,
      required this.color});

  @override
  Widget build(BuildContext context) {
    double ratio = value / totalValue;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Stack(
        children: [
          Container(
            width: width,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              color: color.withOpacity(0.4),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            child: AnimatedContainer(
              height: 7,
              width: width * ratio,
              duration: Duration(milliseconds: totalValue),
              decoration: BoxDecoration(
                color: color,
                // (ratio < 0.3)
                //     ? Colors.red
                //     : (ratio < 0.6)
                //         ? Colors.orange
                //         : (ratio < 0.9)
                //             ? Colors.amber
                //             : Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

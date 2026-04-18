// ignore_for_file: deprecated_member_use
import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class CustomButtom extends StatefulWidget {
  final Color backgroundColor;
  final String text;
  final Widget? icon;
  final void Function()? onTap;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final MainAxisAlignment? mainAxisAlignment;
  const CustomButtom({
    super.key,
    required this.backgroundColor,
    required this.text,
    this.icon,
    this.onTap,
    this.borderColor,
    this.fontSize,
    this.textColor,
    this.mainAxisAlignment,
  });

  @override
  State<CustomButtom> createState() => _CustomButtomState();
}

class _CustomButtomState extends State<CustomButtom> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,

      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.borderColor ?? colors.primary.withOpacity(0.7),
            width: 2.0,
          ),
        ),

        child: Row(
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor ?? colors.onSurface,
                fontSize: widget.fontSize ?? 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontFamily: fontFamily,
              ),
            ),

            if (widget.icon != null) ...[
              const SizedBox(width: 15),
              widget.icon!,
            ],
          ],
        ),
      ),
    );
  }
}

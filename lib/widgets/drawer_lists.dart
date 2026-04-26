import 'package:drift_app/helper/const.dart';
// import 'package:drift_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DrawerLists extends StatelessWidget {
  final Widget? icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? child;
  final void Function()? onLongPress;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? sizedBoxWidth;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final EdgeInsetsGeometry? paddingSecondCont;
  final Decoration? decoration;

  const DrawerLists(
      {super.key,
      this.icon,
      required this.title,
      this.onTap,
      this.child,
      this.onLongPress,
      this.margin,
      this.width,
      this.sizedBoxWidth,
      this.mainAxisAlignment,
      this.padding,
      this.height,
      this.paddingSecondCont,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        height: height ?? 75,
        width: width,
        padding: padding,
        margin: margin ?? const EdgeInsets.only(bottom: 5, left: 25),
        decoration: decoration ??
            BoxDecoration(
              color: colors.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            SizedBox(width: sizedBoxWidth ?? 15),
            if (icon != null) ...[
              Container(
                padding: paddingSecondCont ?? const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon!,
              ),
            ],
            if (child != null) ...[child!],
          ],
        ),
      ),
    );
  }
}

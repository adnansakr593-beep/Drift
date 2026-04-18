import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCont extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderSide? left ;
  final BorderSide? right;
  final BorderSide? top;
  final BorderSide? bottom;
  const GlassCont({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.top,
    this.bottom,
    this.right,
    this.left
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: 320,
            height: height,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: colors.surface.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(19),
              color: Colors.white.withOpacity(0.05),

              border: Border(
                top: top ?? BorderSide.none ,
                left: left ?? BorderSide.none,
                bottom: bottom ?? BorderSide.none,
                right: right ?? BorderSide.none,
              ),


            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

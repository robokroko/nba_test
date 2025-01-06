import 'package:flutter/material.dart';
import 'package:test_application/theme/colors.dart';

class ActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final bool inverse;
  final String text;
  final double? width;
  final double? height;
  final bool enabled;
  final Color? color;
  final double? fontsize;

  const ActionButton({
    super.key,
    this.onPressed,
    this.child,
    this.inverse = false,
    this.text = "",
    this.width,
    this.enabled = true,
    this.color,
    this.height,
    this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
          height: height ?? 50,
          width: width ?? MediaQuery.of(context).size.width,
          child: Material(
            color: color ?? primaryBlueColor,
            elevation: inverse ? 0.1 : 0,
            borderRadius: BorderRadius.circular(45),
            child: Center(
              child: child ??
                  Text(
                    text,
                    style: TextStyle(color: primaryLightColor, fontSize: fontsize ?? 16, fontWeight: FontWeight.bold),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingCircleButton extends StatelessWidget {
  final Color? color;

  const LoadingCircleButton({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
      padding: const EdgeInsets.all(10.0),
      height: 60,
      width: 60,
      child: const Center(
        child: CircularProgressIndicator(
          color: primaryLightColor,
        ),
      ),
    );
  }
}

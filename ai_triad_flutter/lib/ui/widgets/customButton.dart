import 'package:ai_triad/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool isLoading;
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? Center(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : TextButton(
              onPressed: onTap,
              child: Container(
                  decoration: BoxDecoration(
                      color: kcLightGrey,
                      border: Border.all(
                        color: kcPrimaryColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 100),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
    );
  }
}

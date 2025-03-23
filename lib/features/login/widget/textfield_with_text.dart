import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/get_size.dart';
import '../../../core/utils/style_text.dart';

class CustomTextFieldWithTitle extends StatefulWidget {
  CustomTextFieldWithTitle({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.maxLines,
    this.keyboardType,
    this.readonly,
    this.isModify,
    this.textInputAction,
    this.isRequired = true,
    this.withPadding = true,
    this.validator,
  });

 final TextEditingController controller;
 final TextInputAction? textInputAction;
 final String title;
 final String hint;
 final bool? readonly;
 final bool? isModify;
 final TextInputType? keyboardType;
 final int? maxLines;
 final bool isRequired;
 final bool withPadding;
 final String? Function(String?)? validator;
  @override
  _CustomTextFieldWithTitleState createState() =>
      _CustomTextFieldWithTitleState();
}

class _CustomTextFieldWithTitleState extends State<CustomTextFieldWithTitle> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: widget.withPadding ? getSize(context) / 32 : 0,
        vertical: getSize(context) / 44,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: AppStrings.fontFamily,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            maxLines: widget.maxLines ?? 1,
            validator: widget.validator,
            // textDirection: TextDirection.ltr,
            textInputAction: widget.textInputAction,
            readOnly: widget.readonly ?? false,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            obscureText: widget.keyboardType == TextInputType.visiblePassword &&
                !_isPasswordVisible,
            decoration: InputDecoration(
              fillColor: widget.isModify == true
                  ? AppColors.gray.withOpacity(0.25)
                  : AppColors.white,
              contentPadding: const EdgeInsetsDirectional.only(start: 8),
              hintText: widget.hint,
              filled: true,
              hintStyle: widget.isModify == true
                  ? TextStyles.size16FontWidget400Gray
                      .copyWith(color: AppColors.greyColor)
                  : TextStyles.size16FontWidget400Gray,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(getSize(context) / 32),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(getSize(context) / 32),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(getSize(context) / 32),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(getSize(context) / 32),
              ),
              // Add a visibility toggle icon for password fields
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off,
                        color: AppColors.greyColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

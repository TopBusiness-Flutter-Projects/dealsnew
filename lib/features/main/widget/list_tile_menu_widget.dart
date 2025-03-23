import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/get_size.dart';
import '../../../core/widgets/my_svg_widget.dart';

class MenuListTileWidget extends StatelessWidget {
  const MenuListTileWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onclick,
  });

  final String title;
  final String iconPath;
  final VoidCallback onclick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(getSize(context) / 32),
            child: MySvgWidget(
              path: iconPath,
              imageColor: AppColors.white,
              size: getSize(context) / 20,
            ),
          ),
          Flexible(
              child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: getSize(context) / 26,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }
}

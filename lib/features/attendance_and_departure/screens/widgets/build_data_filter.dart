import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildDataFilter extends StatefulWidget {
  BuildDataFilter({super.key, required this.onTap, required this.selectedDate});
  DateTime? selectedDate;
  void Function()? onTap;
  @override
  State<BuildDataFilter> createState() => _BuildDataFilterState();
}
//
class _BuildDataFilterState extends State<BuildDataFilter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedDate != null
                  ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
                  //  DateFormat('yyyy-MM-dd','en').format(widget.selectedDate!)
                  : "data_filter".tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10.sp,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

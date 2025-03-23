import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/date_widget.dart';
import 'package:top_sale/core/utils/textfield_widget.dart';
import 'package:top_sale/features/login/widget/custom_button.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../../../core/utils/style_text.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    context.read<TasksCubit>().changeIndex("01_in_progress");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TasksCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // FAB on bottom left
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            left: 5.0.w, bottom: 80.0.h), // Adjust padding if needed
        child: taskFloatingActionButton(context, cubit),
      ),
      appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "tasks".tr(),
            style: TextStyles.size22FontWidget400White.copyWith(
              color: AppColors.black,
            ),
          )),
      body: BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: taskContainerCustom(
                    cubit: cubit,
                    color: cubit.stateOrder == "01_in_progress"
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.4),
                    title: "new_tasks".tr(),
                  ),
                ),
                Expanded(
                  child: taskContainerCustom(
                    cubit: cubit,
                    color: cubit.stateOrder == "1_done"
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.4),
                    title:  "complete_tasks".tr(),
                  ),
                ),
              ],
            ),
            (cubit.allTasksModel.tasks == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (cubit.allTasksModel.tasks == [])
                    ? Center(
                        child: Text("no_tasks".tr(),
                            style: TextStyles.size14FontWidget400Black),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: cubit.allTasksModel.tasks!.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return TaskCard(
                                index: index,
                                cubit: cubit,
                              );
                            }),
                      )
          ],
        );
      }),
    );
  }

  FloatingActionButton taskFloatingActionButton(
      BuildContext context, TasksCubit cubit) {
    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: AppColors.secondry,
      onPressed: () {
        showAddTasksBottomSheet(context, cubit);
      },
      child: Icon(
        Icons.add,
        color: AppColors.white,
        size: 30.sp,
      ),
    );
  }

  GestureDetector taskContainerCustom(
      {required TasksCubit cubit,
      required String title,
      required Color color}) {
    return GestureDetector(
      onTap: () {
        cubit.changeIndex(
            title == "new_tasks".tr() ? "01_in_progress" : "1_done");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 10.0.sp),
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.sp),
            color: color,
          ),
          child: Center(
              child: Text(title,
                  style: TextStyles.size22FontWidget400White
                      .copyWith(fontSize: 16.sp))),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TasksCubit cubit;
  final int index;

  TaskCard({required this.cubit, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color:
                  Colors.black.withOpacity(0.1), 
              spreadRadius: 1, 
              blurRadius: 4, 
              offset: const Offset(0, 1), 
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: AppColors.gray,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cubit.allTasksModel.tasks![index].deadline == null
                                ? ""
                                : cubit.allTasksModel.tasks![index].deadline
                                    .toString()
                                    .substring(0, 10),
                            style: TextStyles.size16FontWidget400Gray,
                          ),
                        ],
                      ),
                    ],
                  ),
                  cubit.stateOrder == "01_in_progress"
                      ? Icon(
                          Icons.delete_forever_rounded,
                          color: AppColors.red,
                        )
                      : SizedBox()
                ],
              ),
              Text(
                  cubit.allTasksModel.tasks![index].description == false
                      ? ""
                      : cubit.allTasksModel.tasks![index].taskName,
                  style: TextStyles.size16FontWidget400Primary),
              SizedBox(height: 8.sp),
              HtmlWidget(
                cubit.allTasksModel.tasks![index].description == false
                    ? ""
                    : cubit.allTasksModel.tasks![index].description,
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text:  "delivery_time:".tr(),
                      style: TextStyles.size14FontWidget400Black
                          .copyWith(color: AppColors.gray),
                    ),
                    TextSpan(
                        text: cubit.allTasksModel.tasks![index].deadline == null
                            ? ""
                            : cubit.allTasksModel.tasks![index].deadline
                                .toString()
                                .substring(0, 10),
                        style: TextStyles.size14FontWidget400Black),
                  ])),
                  cubit.stateOrder == "01_in_progress"
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0.sp, vertical: 3.0.sp),
                          // ignore: sort_child_properties_last
                          child: GestureDetector(
                            onTap: () {
                              cubit.updateState(
                                  context: context,
                                  taskId: cubit
                                      .allTasksModel.tasks![index].taskId!);
                            },
                            child: Text(
                              "done".tr(),
                              style: TextStyles.size16FontWidget400Gray
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showAddTasksBottomSheet(BuildContext context, TasksCubit cubit) {
  showModalBottomSheet(
    backgroundColor: AppColors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
        var cubit = BlocProvider.of<TasksCubit>(context);

        return Padding(
          padding: EdgeInsets.only(
            left: 16.sp,
            right: 16.sp,
            top: 16.sp,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.sp,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DatePickerField(
                title:  "delivery_time".tr(),
                onTab: () {
                  cubit.onSelectedDate(context);
                },
                selectedDate: cubit.selectedDate,
              ),
              SizedBox(height: 10.h),
              TextFieldWidget(
                  titleFromTextField: "address".tr(),
                  controller: cubit.titleController,
                  hintFromTextField: "add_your_address".tr()),
              SizedBox(height: 20.h),
              TextFieldWidget(
                controller: cubit.tasksController,
                maxLines: 4,
                hintFromTextField: "add_task".tr(),
                titleFromTextField: "task".tr(),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                title: "add".tr(),
                onTap: () {
                  if (cubit.titleController.text.isNotEmpty &&
                      cubit.tasksController.text.isNotEmpty) {
                    cubit.createTask(context: context);
                  }
                },
              )
            ],
          ),
        );
      });
    },
  );
}

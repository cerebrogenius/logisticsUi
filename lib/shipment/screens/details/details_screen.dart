import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/screens/details/cubit/details_cubit.dart';
import 'package:my_bloc_app/shipment/screens/signUp_screen_widgets.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

import '../../models/item_model.dart';
import '../../utilities/constants.dart';

class DetailsScreen extends StatelessWidget {
  final Items item;
  const DetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final detail = BlocProvider.of<DetailsCubit>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10.w),
            height: 500.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: titleAndSub(
                        title: 'Name:', subTitle: item.owner ?? '')),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: titleAndSub(
                        title: 'Email:', subTitle: item.email ?? '')),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: titleAndSub(
                      title: 'Phone Number:', subTitle: item.phoneNumber ?? ''),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: titleAndSub(
                        title: 'Location:', subTitle: item.location ?? '')),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: titleAndSub(
                    title: 'Time:',
                    subTitle: formattedDate(
                      item.date ?? DateTime.now(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child:
                        titleAndSub(title: 'Note:', subTitle: item.note ?? '')),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: titleAndSub(
                        title: 'Status:', subTitle: item.status ?? '')),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomButton(
                        buttonName: 'Update',
                        icon: Icons.update,
                        function: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Fill out the Form'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        const UpdateForm(label: 'Name'),
                                        const UpdateForm(label: 'Note'),
                                        const UpdateForm(label: 'Location'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BlocBuilder<DetailsCubit,
                                                DetailsCubitState>(
                                              builder: (context, state) {
                                                return SelectOption(
                                                  label: _formattedDate(
                                                  state.date ??
                                                        DateTime.now(),
                                                  ),
                                                  widget: IconButton(
                                                    onPressed: () async {
                                                      context
                                                          .read<DetailsCubit>()
                                                          .updateDate(
                                                              await _showDate(
                                                                  context));
                                                    },
                                                    icon: const Icon(
                                                        Icons.calendar_month),
                                                  ),
                                                );
                                              },
                                            ),
                                            const Expanded(
                                              child: SelectOption(
                                                label: 'Status: ',
                                                widget: DropDownStatus(),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formattedDate(DateTime date) {
  return DateFormat.MMMd().format(date);
}

Future<DateTime?> _showDate(BuildContext context) {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(3000),
  );
}

class DropDownStatus extends StatelessWidget {
  const DropDownStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsCubitState>(
      builder: (context, state) {
        return DropdownButton<String>(
          elevation: 10,
          value: state.currentStatus,
          onChanged: (value) {
            context.read<DetailsCubit>().updateStatus(value ?? '');
          },
          items: statusList.map(
            (String e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class SelectOption extends StatelessWidget {
  final String label;
  final Widget widget;
  const SelectOption({
    Key? key,
    required this.label,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 91.w,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          widget,
        ],
      ),
    );
  }
}

class UpdateForm extends StatelessWidget {
  final String label;
  const UpdateForm({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
    );
  }
}

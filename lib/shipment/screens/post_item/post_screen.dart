import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/login_screen.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

class PostItemScreen extends StatelessWidget {
  const PostItemScreen({Key? key}) : super(key: key);
  static TextEditingController nameController = TextEditingController();
  static TextEditingController ownerController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Add Item',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          DetailsForm(
            title: 'Name',
            controller: emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          DetailsForm(
            title: 'Owner Name',
            controller: ownerController,
          ),
          const SizedBox(
            height: 10,
          ),
          DetailsForm(
            title: 'Email',
            controller: ownerController,
          ),
          const SizedBox(
            height: 10,
          ),
          DetailsForm(
            title: 'Phone Number',
            controller: phoneController,
          ),
          const SizedBox(
            height: 10,
          ),
          DetailsForm(
            title: 'Note',
            controller: noteController,
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              DetailsForm(
                title: 'Date',
                controller: phoneController,
              ),
              Positioned(
                right: 32.w,
                bottom: -5,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: BasicDateTimeField(),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          return await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          )
          .then((DateTime? date) async {
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          });
        },
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/models/time_line.dart';
import 'package:my_bloc_app/shipment/screens/details/cubit/details_cubit.dart';
import 'package:my_bloc_app/shipment/screens/signUp_screen_widgets.dart';
import 'package:my_bloc_app/shipment/utilities/snack_bar.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';
import '../../models/item_model.dart';
import '../../network/network_request.dart';
import '../../utilities/constants.dart';
import '../login_screen/cubit/login_cubit.dart';

class DetailsScreen extends StatefulWidget {
  final Items item;
  const DetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);
  static TextEditingController nameController = TextEditingController();
  static TextEditingController noteController = TextEditingController();
  static TextEditingController locationController = TextEditingController();

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detail = BlocProvider.of<DetailsCubit>(context);
    final access = BlocProvider.of<LoginCubit>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<DetailsCubit, DetailsCubitState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DetailsWidget(
                    item: widget.item,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: CustomButton(
                          color: Colors.blue,
                          buttonName: 'Update',
                          icon: Icons.update,
                          function: () async {
                            await showForm(context, detail, access);
                            // setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<DetailsCubit, DetailsCubitState>(
                    builder: (context, state) {
                      return FutureBuilder<List<ItemTimeLine>>(
                        future: HttpRequest()
                            .getItemStream(
                                accessToken:
                                    context.read<LoginCubit>().state.access)
                            .then((value) {
                          List<ItemTimeLine>? list = [];
                          Items itemed = Items();
                          for (Items item in value) {
                            list = itemed.getTimeline(item) ?? [];
                          }
                          return list ?? [];
                        }),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.data.toString()),
                              );
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    return TimeLineWidget(
                                        timeLine: snapshot.data![index]);
                                  }));
                            }
                          }
                          return const SizedBox.shrink();
                        }),
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  showForm(
    BuildContext context,
    DetailsCubit detail,
    LoginCubit access,
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fill out the Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  UpdateForm(
                    label: 'Item',
                    controller: DetailsScreen.nameController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  UpdateForm(
                    label: 'Note',
                    controller: DetailsScreen.noteController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    children: [
                      BlocBuilder<DetailsCubit, DetailsCubitState>(
                        builder: (context, state) {
                          return UpdateForm(
                            click: false,
                            controller: DetailsScreen.locationController,
                            label: 'Location',
                            hint: state.location ?? 'null',
                          );
                        },
                      ),
                      const Positioned(
                        right: 0,
                        bottom: -8,
                        child: DropDownStatusLocation(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<DetailsCubit, DetailsCubitState>(
                        builder: (context, state) {
                          return SelectOption(
                            label: _formattedDate(
                              state.date ?? DateTime.now(),
                            ),
                            widget: IconButton(
                              onPressed: () async {
                                context.read<DetailsCubit>().updateDate(
                                      await _showDate(context),
                                    );
                              },
                              icon: const Icon(Icons.calendar_month),
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
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BlocBuilder<DetailsCubit, DetailsCubitState>(
                    builder: (context, state) {
                      return CustomButton(
                          buttonName: 'Submit',
                          icon: Icons.done,
                          function: () {
                            if (DetailsScreen.nameController.text.isEmpty ||
                                DetailsScreen.noteController.text.isEmpty) {
                              MessageSnackBar().showMessage(
                                  context: context,
                                  message: 'Fields can\'t be empty',
                                  isError: true,
                                  icon: Icons.error);
                              return;
                            } else {
                              final itemed = Items(
                                name: DetailsScreen.nameController.text,
                                note: DetailsScreen.noteController.text,
                                location: detail.state.location,
                                date: detail.state.date,
                                status: detail.state.currentStatus,
                              );
                              detail.editItem(
                                id: widget.item.id ?? '',
                                accessToken: access.state.access,
                                item: itemed,
                              );
                              Navigator.pop(
                                context,
                              );
                            }
                          });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}

class DetailsWidget extends StatelessWidget {
  final Items item;
  final Color? color;
  const DetailsWidget({
    required this.item,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.h,
        left: 8.h,
        right: 8.h,
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 8.h,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.green,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          DetailTile(
            info: item.owner ?? '',
            label: 'Name',
          ),
          DetailTile(
            info: item.name ?? '',
            label: 'Item',
          ),
          DetailTile(
            info: item.email ?? '',
            label: 'Email',
          ),
          DetailTile(
            info: item.phoneNumber ?? '',
            label: 'Phone Number',
          ),
          DetailTile(
            info: item.location ?? '',
            label: 'Location',
          ),
          DetailTile(
            info: formattedDate(
              item.date ?? DateTime.now(),
            ),
            label: 'Time',
          ),
          DetailTile(
            info: item.note ?? '',
            label: 'Note',
          ),
          DetailTile(
            info: item.status ?? '',
            label: 'Status',
          ),
        ],
      ),
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  final ItemTimeLine timeLine;

  const TimeLineWidget({super.key, required this.timeLine});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.h,
        left: 8.h,
        right: 8.h,
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 8.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          // DetailTile(
          //   info: timeLine.name,
          //   label: 'Item',
          // ),
          DetailTile(
            info: timeLine.location,
            label: 'Location',
          ),
          DetailTile(
            info: formattedDate(
              timeLine.date,
            ),
            label: 'Time',
          ),
          DetailTile(
            info: timeLine.note,
            label: 'Note',
          ),
          DetailTile(
            info: timeLine.status,
            label: 'Status',
          ),
        ],
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final String label;
  final String info;
  const DetailTile({
    Key? key,
    required this.info,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10.h,
        left: 10.h,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
        Text(
          info,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
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

class DropDownStatusLocation extends StatelessWidget {
  const DropDownStatusLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsCubitState>(
      builder: (context, state) {
        return DropdownButton<String>(
          elevation: 10,
          value: state.location,
          onChanged: (value) {
            context.read<DetailsCubit>().updateLocation(value ?? 'null2');
          },
          items: locationslist.map(
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
  final bool? click;
  final String label;
  final String? hint;
  final TextEditingController? controller;
  const UpdateForm({
    Key? key,
    required this.label,
    this.controller,
    this.hint,
    this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 25.h,
          child: TextField(
            enabled: click ?? true,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

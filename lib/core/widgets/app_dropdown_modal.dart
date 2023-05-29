import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/models/dropdown_base_model.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';
import '../utils/styles.dart';
import 'app_textfield.dart';

class AppDropdownModal<T> extends StatefulWidget {
  final String? headerText;
  final String? descriptionText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final List<T> options;
  final T? value;
  final bool hasSearch;
  final String? parentName;
  final double modalHeight;
  final ValueChanged<T?> onChanged;

  const AppDropdownModal({
    Key? key,
    this.headerText,
    this.hintText,
    this.enabled = true,
    required this.onChanged,
    this.validator,
    this.parentName,
    this.descriptionText,
    required this.options,
    this.value,
    required this.modalHeight,
    this.hasSearch = false,
  }) : super(key: key);

  @override
  State<AppDropdownModal> createState() => _AppDropdownModalState();
}

class _AppDropdownModalState<T extends DropdownBaseModel>
    extends State<AppDropdownModal> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<T> filteredItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      controller.text = widget.value;
    } else {
      controller.clear();
    }
    if (searchController.text.isEmpty) {
      filteredItems = widget.options.cast<T>();
    }
    return AppTextField(
      headerText: widget.headerText,
      hintText: widget.hintText,
      descriptionText: widget.descriptionText,
      enabled: widget.enabled,
      readOnly: true,
      // onChanged: widget.onChanged,
      validator: widget.validator,
      controller: controller,
      suffixWidget: Container(
          width: 20.w,
          height: 20.h,
          margin: EdgeInsets.only(right: 20),
          child: SvgPicture.asset('assets/svgs/drop_grey.svg')),
      onTap: () async {
        if (filteredItems.isEmpty) return;
        _showModal(widget.headerText != null ? widget.headerText! : '');
      },
    );
  }

  void _showModal(String headerText) {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: AppColors.sonaWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalState) {
            return Wrap(
              children: [
                SizedBox(
                  height: widget.modalHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                headerText.trim().endsWith('*')
                                    ? headerText.trim().substring(
                                        0, headerText.trim().lastIndexOf('*'))
                                    : headerText.trim(),
                                textAlign: TextAlign.center,
                                style: AppStyle.text3.copyWith(
                                  color: AppColors.sonaGrey3,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 13.w),
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    Boxicons.bx_x,
                                    color: AppColors.sonaGrey3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //_separator,
                        SizedBox(height: 13.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.hasSearch
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          List temp = widget.options
                                              .where((element) => element
                                                  .displayName
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                          setModalState(() {
                                            filteredItems = temp as List<T>;
                                          });
                                        },
                                        style: AppStyle.text2,
                                        decoration: InputDecoration(
                                          fillColor: AppColors.sonaGrey6,
                                          isDense: true,
                                          filled: true,
                                          prefixIcon: Icon(
                                            Boxicons.bx_search,
                                            color: AppColors.sonaGrey3,
                                            size: 30,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .normalRadius),
                                              borderSide: BorderSide(
                                                  color: AppColors.sonaGrey6)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15.h, horizontal: 12.w),
                                          border: InputBorder.none,
                                          hintText: "search",
                                          hintStyle: AppStyle.text2,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              widget.hasSearch
                                  ? SizedBox(height: 10.h)
                                  : const SizedBox.shrink(),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: filteredItems.length,
                                  separatorBuilder: (_, index) =>
                                      Container(), //_separator,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        // vertical: 13.h,
                                      ),
                                      title: Text(
                                        filteredItems[index].displayName!,
                                        style: AppStyle.text2.copyWith(
                                            color: AppColors.sonaGrey2),
                                      ),
                                      onTap: () {
                                        // setState(() {
                                        controller.text =
                                            filteredItems[index].displayName!;
                                        // });
                                        widget.onChanged(filteredItems[index]);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

final Divider _separator = Divider(
  height: 1.h,
  thickness: 0.3,
  color: AppColors.sonaDisabledGrey,
);

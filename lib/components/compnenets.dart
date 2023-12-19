import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../screens/new_course_content/cubit/cubit.dart';

Widget myTextFormField({
  required BuildContext context,
  TextEditingController? controller,
  TextInputType? type,
  bool? isPassword,
  VoidCallback? onTap,
  ValueChanged<String>? onChange,
  String? Function(String?)? validate,
  ValueChanged<String>? onSubmit,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? icon,
  int? maxLength,
  int? maxLength2,
  Color? fillColor,
  Color? hintColor,
  Color? textColor,
  TextAlign? textAlign,
  String? hint,
  double? radius,
  int? minLines,
  int? maxLines,
  bool? isEnabled = true,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  Key? key,
  double? contentPaddingHz,
  InputBorder? border,
  InputBorder? enabledBorder,
  bool? isExpanded,
}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 0),
        ),
        shape: BoxShape.rectangle,
      ),
      child: TextFormField(
        onTapOutside: (event) {
          BlocProvider.of<CourseContentCubit>(context).changeKeyboard(false);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        key: key,
        obscuringCharacter: '●',
        focusNode: focusNode,
        controller: controller,
        enabled: isEnabled ?? true,
        keyboardType: type,
        obscureText: isPassword ?? false,
        textAlignVertical: TextAlignVertical.center,
        onTap: onTap,
        expands: isExpanded ?? false,
        onChanged: (value) {
          if (onChange != null) {
            final oldValueSelection = controller?.selection;
            onChange(value);
            controller?.value = TextEditingValue(
              text: value,
              selection: oldValueSelection!,
            );
          }
        },
        textInputAction: textInputAction ?? TextInputAction.done,
        onFieldSubmitted: onSubmit,
        validator: validate,
        textAlign: textAlign ?? TextAlign.start,
        maxLength: maxLength,
        minLines: minLines ?? 1,
        maxLines: minLines ?? 1,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength2),
        ],
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: textColor ?? ColorConstants.lightBlue),
        decoration: InputDecoration(
          filled: true,
          counterStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: ColorConstants.darkBlue),
          fillColor: fillColor ?? ColorConstants.darkBlue.withOpacity(0.5),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
                borderSide: BorderSide(
                  color: ColorConstants.darkBlue,
                ),
              ),
          border: fillColor == null
              ? InputBorder.none
              : border ??
                  OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(radius ?? 0)),
                    borderSide: BorderSide(
                      color: ColorConstants.darkBlue,
                    ),
                  ),
          hintText: hint ?? '',
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: hintColor ?? ColorConstants.lightBlue,
              overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPaddingHz ?? 16, vertical: 4),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
        ),
      ),
    );

Future<dynamic> showMyBottomSheet({
  required BuildContext context,
  required Widget child,
  Color? bgColor,
  Color? brColor,
  double? maxHeight,
}) {
  final completer = Completer<void>();
  return showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? MediaQuery.of(context).size.height - 80,
    ),
    isScrollControlled: true,
    barrierColor: brColor ?? Colors.black38,
    backgroundColor: bgColor ?? Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
                color: bgColor ?? Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: child,
          ),
        );
      });
    },
  ).whenComplete(() {
    if (!completer.isCompleted) {
      completer.complete();
    }
    return completer.future;
  });
}

Widget myMaterialButton({
  required BuildContext context,
  required Function onPressed,
  Widget? labelWidget,
  bool isEnabled = true,
  Color? bgColorForNotEnabled,
  double height = 58,
  double radius = 20,
  List<double>? customRadiusTlTrBlBr,
  Color? bgColor,
  Color? borderColor,
}) =>
    MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onPressed();
      },
      color: isEnabled
          ? bgColor ?? ColorConstants.lightBlue
          : bgColorForNotEnabled ?? ColorConstants.lightBlue,
      minWidth: double.infinity,
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: customRadiusTlTrBlBr == null
              ? BorderRadius.circular(radius)
              : BorderRadius.only(
                  topLeft: Radius.circular(customRadiusTlTrBlBr[0]),
                  topRight: Radius.circular(customRadiusTlTrBlBr[1]),
                  bottomLeft: Radius.circular(customRadiusTlTrBlBr[2]),
                  bottomRight: Radius.circular(customRadiusTlTrBlBr[3])),
          side: BorderSide(color: borderColor ?? ColorConstants.lightBlue)),
      child: labelWidget,
    );

Widget myDivider({
  double? height,
  double? paddingHz,
  double? paddingVr,
  double? width,
  Color? color,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHz ?? 10.0, vertical: paddingVr ?? 0),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 0.5,
        color: color ?? Colors.grey,
      ),
    );

void showProgressIndicator({
  required BuildContext context,
  String? text,
}) {
  AlertDialog alertDialog = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.black38,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorConstants.lightBlue),
            ),
            if (text != null)
              SizedBox(
                height: 10,
              ),
            if (text != null) Text(text, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );
  showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      builder: (context) {
        return alertDialog;
      });
}

Widget myDropDownButton({
  required BuildContext context,
  required List<String> dropMenuItems,
  required String selectedValue,
  Widget? prefix,
  String? hintText,
  Color? hintColor,
  Color? bgColor,
  Color? textColor,
  Color? iconColor,
  Color? dropdownColor,
  Color? dropMenuItemColor,
  void Function(String?)? onChange,
  EdgeInsetsGeometry? contentPadding,
}) =>
    DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: hintColor ?? Colors.black),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: Row(
        children: [
          if (prefix != null) prefix,
          if (prefix != null)
            const SizedBox(
              width: 20,
            ),
          Flexible(
            child: Text(
              hintText ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: hintColor ?? Colors.black),
            ),
          ),
        ],
      ),
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontSize: 14, color: textColor ?? Colors.white),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: iconColor ?? Colors.black,
        ),
      ),
      buttonStyleData: ButtonStyleData(
          height: 48,
          padding: contentPadding ?? const EdgeInsets.only(right: 0, left: 0),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          )),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: dropdownColor ?? Colors.white,
        ),
      ),
      items: dropMenuItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                onTap: () {
                  selectedValue = item;
                },
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: dropMenuItemColor ?? Colors.black, fontSize: 11),
                ),
              ))
          .toList(),
      onChanged: onChange,
      onSaved: (value) {
        selectedValue = value.toString();
      },
    );

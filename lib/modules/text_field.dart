import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String? fieldHeading;
  final String? hintText;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;

  const TextFormFieldWidget(
      {Key? key,
      required this.fieldHeading,
      required this.textEditingController,
      required this.hintText,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldHeading!,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: FontConstants.poppins),
          ),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: ColorConstants.lightBlue,
            style: const TextStyle(
                fontSize: 15, fontFamily: FontConstants.poppins),
            decoration: InputDecoration(
              hintText: hintText!,
              hintStyle: const TextStyle(
                  fontSize: 15, fontFamily: FontConstants.poppins),
              contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: ColorConstants.lightBlue, width: 5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
            ),
            controller: textEditingController,
            validator: (value) {
              return value!.length > 3 ? null : 'Enter valid username';
            },
          )
        ],
      ),
    );
  }
}

class PasswordTextFormFieldWidget extends StatefulWidget {
  final String? fieldHeading;
  final String? hintText;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;

  const PasswordTextFormFieldWidget(
      {Key? key,
      @required this.fieldHeading,
      @required this.textEditingController,
      @required this.hintText,
      @required this.validator})
      : super(key: key);

  @override
  State<PasswordTextFormFieldWidget> createState() =>
      _PasswordTextFormFieldWidgetState();
}

class _PasswordTextFormFieldWidgetState
    extends State<PasswordTextFormFieldWidget> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldHeading!,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: FontConstants.poppins),
          ),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: ColorConstants.lightBlue,
            style: const TextStyle(
                fontSize: 15, fontFamily: FontConstants.poppins),
            obscureText: showPassword ? false : true,
            decoration: InputDecoration(
              hintText: widget.hintText!,
              suffixIcon: showPassword
                  ? GestureDetector(
                      onTap: () => setState(() => showPassword
                          ? showPassword = false
                          : showPassword = true),
                      child: const Icon(Icons.visibility))
                  : GestureDetector(
                      onTap: () => setState(() => showPassword
                          ? showPassword = false
                          : showPassword = true),
                      child: const Icon(Icons.visibility_off)),
              hintStyle: const TextStyle(
                  fontSize: 15, fontFamily: FontConstants.poppins),
              contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: ColorConstants.lightBlue, width: 5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConstants.lightBlue)),
            ),
            controller: widget.textEditingController,
            validator: widget.validator,
          )
        ],
      ),
    );
  }
}

class DropDownFormField extends StatefulWidget {
  final String? fieldHeading;
  final String? hintText;
  late final String? valueName;
  final List? listValues;

  DropDownFormField(
      {Key? key,
      @required this.hintText,
      @required this.listValues,
      @required this.valueName,
      @required this.fieldHeading})
      : super(key: key);

  @override
  State<DropDownFormField> createState() => _DropDownFormFieldState();
}

class _DropDownFormFieldState extends State<DropDownFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldHeading!,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: FontConstants.poppins),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            iconDisabledColor: Colors.grey,
            iconEnabledColor: Colors.black,
            value: widget.valueName,
            items: widget.listValues?.map((universities) {
              return DropdownMenuItem(
                value: universities,
                child: Text("$universities"),
              );
            }).toList(),
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                hintText: tr(StringConstants.select_company_name),
                hintStyle: const TextStyle(
                    fontSize: 15, fontFamily: FontConstants.poppins),
                contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.indigo[900]!)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.indigo[900]!)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.indigo[900]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.indigo[900]!)),
                errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.red)),
                hoverColor: Colors.white,
                errorStyle: const TextStyle(color: Colors.white, fontSize: 14)),
            onChanged: (value) =>
                setState(() => widget.valueName = value as String?),
            validator: (val) {
              return val != null ? null : tr(StringConstants.select_company_name);
            },
          ),
        ],
      ),
    );
  }
}

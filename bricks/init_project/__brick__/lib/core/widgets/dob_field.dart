import 'package:flutter/material.dart';

typedef OnDateChanged = void Function(DateTime);

class DobField extends StatefulWidget {
  final OnDateChanged onDatePicked;
  final DateTime? initialDate;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final GlobalKey<FormState>? formKey;
  final TextEditingController controller;
  final String? errorText;
  final DateTime? lastDate;
  final bool hasPrefixIcon;
  final DateTime? firstDate;

  const DobField({
    super.key,
    this.hintText = 'Select',
    required this.controller,
    this.validator,
    required this.onDatePicked,
    this.initialDate,
    this.formKey,
    this.errorText,
    this.lastDate,
    this.hasPrefixIcon = true,
    this.firstDate,
  });

  @override
  State<DobField> createState() => _DobFieldState();
}

class _DobFieldState extends State<DobField> {
  late final DateTime lastDate;
  @override
  void initState() {
    if (widget.initialDate != null) {
      setFormattedDate(widget.initialDate!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDatePicked(widget.initialDate!);
      });
    }
    lastDate = widget.lastDate ??
        (DateTime.now().subtract(const Duration(days: 365 * 16)));
    super.initState();
  }

  setFormattedDate(DateTime date) {
    final day = date.day < 10 ? '0${date.day}' : date.day;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    widget.controller.text = '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        final date = await showDatePicker(
          helpText: '',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: Theme.of(context).dividerTheme,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
          keyboardType: TextInputType.datetime,
          context: context,
          initialDate: widget.controller.text.isNotEmpty
              ? DateTime.tryParse(widget.controller.text)
              : widget.initialDate ?? DateTime.now(),
          firstDate: widget.firstDate ?? DateTime(1970),
          lastDate: widget.lastDate ?? lastDate,
        );

        if (date != null) {
          setState(() {
            setFormattedDate(date);
          });

          widget.onDatePicked(date);
          widget.formKey?.currentState?.validate();
        }
      },
      controller: widget.controller,
      readOnly: true,
      autofocus: false,
      enableInteractiveSelection: false,
      showCursor: false,
      validator: widget.validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.black,
          ),
      decoration: InputDecoration(
        errorText: widget.errorText,
        prefixIcon: widget.hasPrefixIcon
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.calendar_today, color: Colors.grey),
              )
            : null,
        hintText: widget.hintText,
        border: InputBorder.none,
      ),
    );
  }
}

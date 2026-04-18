import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench_and_bolts/core/enums/enums.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';

import 'package:wrench_and_bolts/core/widgets/country_selector.dart';
import 'package:wrench_and_bolts/features/profile/models/country_response.dart';
import 'package:wrench_and_bolts/features/profile/providers/countries_provider.dart';

class ContactField extends ConsumerWidget {
  final CountryResponseDatum? initialCountry;
  final String? initialPhoneNumber;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<CountryResponseDatum>? onCountryChanged;
  final ValueChanged<ContactFieldValue>? onChanged;
  final String? phoneHintText;
  final String? phoneErrorText;
  final AuthenticationContext? authContext;
  final bool enabled;
  final bool showCountryName;
  final bool autofocus;
  final TextStyle? phoneTextStyle;
  final TextStyle? countryTextStyle;
  final FormFieldValidator<ContactFieldValue>? validator;
  final FormFieldSetter<ContactFieldValue>? onSaved;
  final AutovalidateMode autovalidateMode;

  const ContactField({
    super.key,
    this.initialCountry,
    this.initialPhoneNumber,
    this.onPhoneChanged,
    this.onCountryChanged,
    this.onChanged,
    this.phoneHintText = 'Enter Mobile number',
    this.phoneErrorText = 'Please enter a valid phone number',
    this.authContext,
    this.enabled = true,
    this.showCountryName = false,
    this.autofocus = false,
    this.phoneTextStyle,
    this.countryTextStyle,
    this.validator,
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return countriesAsync.when(
      loading: () => _buildLoading(),
      error: (error, stackTrace) => _buildError(error),
      data: (countries) {
        final firstCountry = initialCountry ??
            (countries.isNotEmpty
                ? countries[0]
                : CountryResponseDatum(
                    code: '123', name: 'Unknown', flag: '🏳️'));

        return _ContactFieldForm(
          initialCountry: firstCountry,
          initialPhoneNumber: initialPhoneNumber,
          onPhoneChanged: onPhoneChanged,
          onCountryChanged: onCountryChanged,
          onChanged: onChanged,
          phoneHintText: phoneHintText,
          phoneErrorText: phoneErrorText,
          authContext: authContext,
          showCountryName: showCountryName,
          autofocus: autofocus,
          phoneTextStyle: phoneTextStyle,
          countryTextStyle: countryTextStyle,
          enabled: enabled,
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 60,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Failed to fetch countries',
        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
      ),
    );
  }
}

class _ContactFieldForm extends FormField<ContactFieldValue> {
  _ContactFieldForm({
    required CountryResponseDatum initialCountry,
    required String? initialPhoneNumber,
    required ValueChanged<String>? onPhoneChanged,
    required ValueChanged<CountryResponseDatum>? onCountryChanged,
    required ValueChanged<ContactFieldValue>? onChanged,
    required String? phoneHintText,
    required String? phoneErrorText,
    required AuthenticationContext? authContext,
    required bool showCountryName,
    required bool autofocus,
    required TextStyle? phoneTextStyle,
    required TextStyle? countryTextStyle,
    required bool enabled,
    required FormFieldValidator<ContactFieldValue>? validator,
    required FormFieldSetter<ContactFieldValue>? onSaved,
    required AutovalidateMode autovalidateMode,
  }) : super(
          initialValue: ContactFieldValue(
            country: initialCountry,
            phoneNumber: initialPhoneNumber ?? '',
          ),
          enabled: enabled,
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<ContactFieldValue> state) {
            return _ContactFieldWidget(
              state: state,
              initialCountry: initialCountry,
              initialPhoneNumber: initialPhoneNumber,
              onPhoneChanged: onPhoneChanged,
              onCountryChanged: onCountryChanged,
              onChanged: onChanged,
              phoneHintText: phoneHintText,
              phoneErrorText: phoneErrorText,
              authContext: authContext,
              showCountryName: showCountryName,
              autofocus: autofocus,
              phoneTextStyle: phoneTextStyle,
              countryTextStyle: countryTextStyle,
              enabled: enabled,
            );
          },
        );
}

class _ContactFieldWidget extends StatefulWidget {
  final FormFieldState<ContactFieldValue> state;
  final CountryResponseDatum? initialCountry;
  final String? initialPhoneNumber;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<CountryResponseDatum>? onCountryChanged;
  final ValueChanged<ContactFieldValue>? onChanged;
  final String? phoneHintText;
  final String? phoneErrorText;
  final AuthenticationContext? authContext;
  final bool showCountryName;
  final bool autofocus;
  final TextStyle? phoneTextStyle;
  final TextStyle? countryTextStyle;
  final bool enabled;

  const _ContactFieldWidget({
    Key? key,
    required this.state,
    required this.initialCountry,
    required this.initialPhoneNumber,
    required this.onPhoneChanged,
    required this.onCountryChanged,
    required this.onChanged,
    required this.phoneHintText,
    required this.phoneErrorText,
    required this.authContext,
    required this.showCountryName,
    required this.autofocus,
    required this.phoneTextStyle,
    required this.countryTextStyle,
    required this.enabled,
  }) : super(key: key);

  @override
  State<_ContactFieldWidget> createState() => _ContactFieldWidgetState();
}

class _ContactFieldWidgetState extends State<_ContactFieldWidget> {
  late CountryResponseDatum _selectedCountry;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _selectedCountry = widget.state.value?.country ??
        widget.initialCountry ??
        CountryResponseDatum(code: '123', name: 'Unknown', flag: '🏳️');

    _phoneController = TextEditingController(
      text: widget.state.value?.phoneNumber ?? widget.initialPhoneNumber ?? '',
    );
    _phoneController.addListener(_updateValue);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updateValue);
    _phoneController.dispose();
    super.dispose();
  }

  void _updateValue() {
    final value = ContactFieldValue(
      country: _selectedCountry,
      phoneNumber: _phoneController.text.trim(),
    );

    widget.state.didChange(value);
    widget.onPhoneChanged?.call(_phoneController.text);
    widget.onChanged?.call(value);
  }

  void _onCountryChanged(CountryResponseDatum country) {
    setState(() {
      _selectedCountry = country;
    });

    final value = ContactFieldValue(
      country: country,
      phoneNumber: _phoneController.text.trim(),
    );

    widget.state.didChange(value);
    widget.onCountryChanged?.call(country);
    widget.onChanged?.call(value);
  }

  void _showCountryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (BuildContext context) => CountrySelectorBottomSheet(
        selectedCountry: _selectedCountry,
        onCountryChanged: _onCountryChanged,
        showSearch: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.state.hasError;
    final errorText = widget.state.errorText;
    final borderColor = Color(0xFF000000);

    const borderRadius = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Country Selector
            GestureDetector(
              onTap: widget.enabled ? _showCountryBottomSheet : null,
              child: Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (_selectedCountry.flag ?? '').unicodeToEmoji,
                      style: widget.countryTextStyle ??
                          Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedCountry.code ?? '',
                      style: widget.countryTextStyle ??
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                              ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            ),

            // Phone Number Field
            // Phone Number Field - Completely clean (no border)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: borderColor),
                    right: BorderSide(color: borderColor),
                    bottom: BorderSide(color: borderColor),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius),
                  ),
                ),
                child: TextField(
                  controller: _phoneController,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  style: widget.phoneTextStyle,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: widget.phoneHintText,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Error Text
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 6),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class ContactFieldValue {
  final CountryResponseDatum country;
  final String phoneNumber;

  const ContactFieldValue({
    required this.country,
    required this.phoneNumber,
  });

  String get fullPhoneNumber => '${country.code}$phoneNumber';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactFieldValue &&
          runtimeType == other.runtimeType &&
          country == other.country &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => country.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() =>
      'ContactFieldValue{country: $country, phoneNumber: $phoneNumber}';
}

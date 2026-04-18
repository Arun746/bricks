import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wrench_and_bolts/core/styles/assets.dart';

class IncrementDecrementSelector extends StatefulWidget {
  final String? imagePath;
  final double? minValue;
  final double? maxValue;
  final double initialValue;
  final int? maxInputLength;
  final TextEditingController controller;
  final String? prefixText;
  final double stepValue;

  const IncrementDecrementSelector({
    Key? key,
    this.imagePath,
    this.minValue,
    this.maxValue,
    required this.controller,
    this.maxInputLength,
    this.initialValue = 0.0,
    this.prefixText,
    this.stepValue = 0.5,
  }) : super(key: key);

  @override
  _IncrementDecrementSelectorState createState() =>
      _IncrementDecrementSelectorState();
}

class _IncrementDecrementSelectorState
    extends State<IncrementDecrementSelector> {
  double _currentValue = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    if (widget.minValue != null && _currentValue < widget.minValue!) {
      _currentValue = widget.minValue!;
    }
    if (widget.maxValue != null && _currentValue > widget.maxValue!) {
      _currentValue = widget.maxValue!;
    }
    // Defer initial text assignment to avoid notifying listeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.text = _currentValue % 1 == 0
          ? _currentValue.toStringAsFixed(0)
          : _currentValue.toString();
      // Place cursor at the end
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
      _validateInput(_currentValue);
    });

    widget.controller.addListener(() {
      _onTextChanged(widget.controller.text);
    });
  }

  void _validateInput(double value) {
    if (!mounted) return;
    setState(() {
      _errorMessage = null;
      if (widget.minValue != null && value < widget.minValue!) {
        _errorMessage = 'Amount too low! Minimum is ${widget.minValue}';
      } else if (widget.maxValue != null && value > widget.maxValue!) {
        _errorMessage = 'Amount too high! Maximum is ${widget.maxValue}';
      }
    });
  }

  void _increment() {
    if (!mounted) return;
    setState(() {
      if (widget.maxValue == null || _currentValue < widget.maxValue!) {
        _currentValue += widget.stepValue;
        // Format to remove unnecessary trailing zeros
        widget.controller.text = _currentValue % 1 == 0
            ? _currentValue.toStringAsFixed(0)
            : _currentValue.toString();
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
        _validateInput(_currentValue);
      }
    });
  }

  void _decrement() {
    if (!mounted) return;
    setState(() {
      if (widget.minValue == null || _currentValue > widget.minValue!) {
        _currentValue -= widget.stepValue;
        // Format to remove unnecessary trailing zeros
        widget.controller.text = _currentValue % 1 == 0
            ? _currentValue.toStringAsFixed(0)
            : _currentValue.toString();
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
        _validateInput(_currentValue);
      }
    });
  }

  void _onTextChanged(String value) {
    if (!mounted) return;
    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'Please enter a valid number';
        return;
      }

      double? newValue = double.tryParse(value);
      if (newValue != null) {
        _currentValue = newValue;
        if (widget.minValue != null && _currentValue < widget.minValue!) {
          _currentValue = widget.minValue!;
        }
        if (widget.maxValue != null && _currentValue > widget.maxValue!) {
          _currentValue = widget.maxValue!;
        }
        if (_currentValue != newValue) {
          widget.controller.text = _currentValue % 1 == 0
              ? _currentValue.toStringAsFixed(0)
              : _currentValue.toString();
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
        _validateInput(_currentValue);
      } else {
        _errorMessage = 'Please enter a valid number';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.imagePath != null) ...[
                Image.asset(
                  widget.imagePath ?? '',
                  width: 26,
                  height: 26,
                ),
              ],
              if (widget.prefixText != null) ...[
                Text(
                  widget.prefixText ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF939393),
                        fontSize: 14,
                      ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    if (widget.maxInputLength != null)
                      LengthLimitingTextInputFormatter(widget.maxInputLength),
                  ],
                  onChanged: _onTextChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
              Column(
                children: [
                  InkWell(
                      onTap: _increment,
                      child: SvgPicture.asset(
                        AssetsPath.incrementIcon,
                        width: 16,
                      )),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: _decrement,
                      child: SvgPicture.asset(
                        AssetsPath.decrementIcon,
                        width: 16,
                      )),
                ],
              ),
            ],
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

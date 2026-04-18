import 'package:flutter/material.dart';

class InfoFormAppbar extends StatelessWidget {
  final double progress;
  final VoidCallback? onBackPressed;

  const InfoFormAppbar({
    super.key,
    this.progress = 0.0,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBackPressed != null)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
          ),
        const Spacer(),
        FormProgressBar(progress: progress),
      ],
    );
  }
}

class FormProgressBar extends StatelessWidget {
  final double progress;
  const FormProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(progress * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 120,
          height: 8,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}

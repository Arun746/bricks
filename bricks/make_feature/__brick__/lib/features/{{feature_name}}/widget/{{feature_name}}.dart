import 'package:flutter/material.dart';

class {{feature_name.pascalCase()}} extends StatelessWidget {
  const {{feature_name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('{{feature_name.pascalCase()}}'),
      ),
    );
  }
}
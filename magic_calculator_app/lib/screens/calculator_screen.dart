import 'package:flutter/material.dart';
import 'package:magic_calculator_app/widgets/header_display.dart';
import 'package:magic_calculator_app/widgets/input_pad.dart';
import 'package:magic_calculator_app/widgets/theme_app_bar.dart';

const kSidePadding = 14.0;

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(child: HeaderDisplay()),
          InputPad(),
          SizedBox(height: kSidePadding),
        ],
      ),
    );
  }
}

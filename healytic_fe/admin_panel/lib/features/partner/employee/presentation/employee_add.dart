import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_add_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      debugPrint(_formKey.currentState?.value.toString());
      // TODO: Handle submission
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: ResponsiveWrapper(
        useLayout: true,
        desktop: EmployeeAddDesktop(
          onCancel: _handleCancel,
          onSubmit: _handleSubmit,
        ),
      ),
    );
  }
}

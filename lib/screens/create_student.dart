import 'dart:convert';

import 'package:demo/models.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/student_form.dart';
import 'package:http/http.dart' as http;

class CreateStudentScreen extends StatelessWidget {
  const CreateStudentScreen({super.key});

  Future<http.Response> postStudent(Student student) async {
    const String url = 'http://localhost:3000/students';

    final res = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(student.toMap()));

    return res;
  }

  void onSubmit({required Student formData, required BuildContext context}) {
    postStudent(formData).then((res) {
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Student created successfully!"),
          duration: Duration(seconds: 1),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to create Student!"),
          duration: Duration(seconds: 1),
        ));
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create A New Screen"),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: Center(
        child: StudetnForm(
          onSubmit: onSubmit,
        ),
      ),
    );
  }
}

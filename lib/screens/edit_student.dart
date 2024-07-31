import 'dart:convert';

import 'package:demo/models.dart';
import 'package:demo/widgets/student_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStudentScreen extends StatelessWidget {
  const EditStudentScreen({super.key, required this.student, required this.setStudent});

  final Student student;
  final void Function(Student) setStudent;

  Future<http.Response> editStudent(Student student) async {
    debugPrint("inside edit: ${student.id}");
    String url = 'http://localhost:3000/students/${student.id}';

    final res = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(student.toMap()));

    return res;
  }

  void onSubmit({required Student formData, required BuildContext context}) {
    editStudent(formData).then((res) {
      if (res.statusCode == 200) {
        setStudent(Student.fromJson(jsonDecode(res.body)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Student Edited Successfully!"),
          duration: Duration(seconds: 1),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to Edit Student!"),
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
        title: const Text("Edit Student"),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: StudetnForm(
        initialStudentData: student,
        onSubmit: onSubmit,
      ),
    );
  }
}

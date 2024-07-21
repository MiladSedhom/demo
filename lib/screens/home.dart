import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Demo"),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: const Center(
        child: StudentView(),
      ),
    );
  }
}

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  List<Student> students = [];

  final limit = 5;
  var page = 0;
  final String url = 'http://localhost:3000/students';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchStudent('$url?limit=$limit&page=$page').then((data) {
      setState(() {
        students = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : students.isNotEmpty
                  ? ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          title: Text(students[index].firstName),
                          subtitle: Text(students[index].lastName),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No More Students"),
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 'firstName',
                  child: Text("First Name"),
                ),
                DropdownMenuItem(
                  value: 'lastName',
                  child: Text("Last Name"),
                ),
              ],
              onChanged: (selectedValue) {
                setState(() {
                  if (selectedValue == "firstName") {
                    students.sort((a, b) => a.firstName.compareTo(b.firstName));
                  } else if (selectedValue == "lastName") {
                    students.sort((a, b) => a.lastName.compareTo(b.lastName));
                  }
                });
              },
              hint: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Sort by"),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    students = students.reversed.toList();
                  });
                },
                icon: Transform.rotate(
                    angle: 90 * 3.14 / 180,
                    child: const Icon(
                      Icons.compare_arrows_rounded,
                    )))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  page = page > 0 ? page - 1 : 0;
                  setState(() {
                    isLoading = true;
                  });
                  var data = await fetchStudent('$url?limit=$limit&page=$page');
                  setState(() {
                    students = data;
                    isLoading = false;
                  });
                },
                child: const Text("Previous")),
            TextButton(
                onPressed: () async {
                  page = page + 1;
                  setState(() {
                    isLoading = true;
                  });
                  var data = await fetchStudent('$url?limit=$limit&page=$page');
                  setState(() {
                    students = data;
                    isLoading = false;
                  });
                },
                child: const Text("Next")),
          ],
        ),
      ],
    );
  }
}

Future<List<Student>> fetchStudent(String url) async {
  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    List<dynamic> data = jsonDecode(res.body);
    List<Student> students = data.map((item) => Student.fromJson(item)).toList();
    debugPrint(students.length.toString());
    for (var s in students) {
      debugPrint(s.firstName);
    }

    return students;
  } else {
    throw Exception("Failed to load Students, Status code: ${res.statusCode}");
  }
}

class Student {
  final String firstName;
  final String lastName;

  Student({
    required this.firstName,
    required this.lastName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'firstName': String firstName,
        'lastName': String lastName,
      } =>
        Student(
          firstName: firstName,
          lastName: lastName,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

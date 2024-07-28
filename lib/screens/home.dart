import "dart:convert";

import "package:demo/screens/create_student.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: const Center(
        child: StudentView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          '+',
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateStudentScreen(),
            ),
          );
        },
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
  bool isLoading = true;
  String error = '';

  final limit = 5;
  var page = 0;
  var sortBy = "";
  var sortType = "asc";

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              if (isLoading == true) {
                return const Center(child: CircularProgressIndicator());
              } else if (error.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(error),
                  ),
                );
              } else if (students.isNotEmpty) {
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      title: Text(students[index].firstName),
                      subtitle: Text(students[index].lastName),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No More Students"),
                );
              }
            },
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
                  sortBy = selectedValue!;
                });
                fetchStudent();
              },
              hint: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Sort by"),
              ),
            ),
            IconButton(
                onPressed: () {
                  sortType = sortType == "asc" ? "desc" : "asc";
                  fetchStudent();
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
                  fetchStudent();
                },
                child: const Text("Previous")),
            TextButton(
                onPressed: () async {
                  page = page + 1;
                  fetchStudent();
                },
                child: const Text("Next")),
          ],
        ),
      ],
    );
  }

  Future<void> fetchStudent() async {
    const String url = 'http://localhost:3000/students';
    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse('$url?limit=$limit&page=$page&sortBy=$sortBy&sortType=$sortType'));

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        setState(() {
          students = data.map((item) => Student.fromJson(item)).toList();
        });
      } else {
        setState(() {
          error = 'Error getting students, server responded with code: ${res.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to Reach The Server.';
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}

class Student {
  final String id;
  final String firstName;
  final String lastName;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'firstName': String firstName,
        'lastName': String lastName,
      } =>
        Student(
          id: id,
          firstName: firstName,
          lastName: lastName,
        ),
      _ => throw const FormatException('Failed to load student.'),
    };
  }
}

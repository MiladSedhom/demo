import 'package:demo/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class StudetnForm extends StatefulWidget {
  const StudetnForm({super.key, this.onSubmit, this.initialValues});

  final void Function({
    required String formData,
    required BuildContext context,
  })? onSubmit;
  final Student? initialValues;

  @override
  State<StudetnForm> createState() => _StudetnFormState();
}

class _StudetnFormState extends State<StudetnForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  List<Skill> skills = [];
  List<Address> addresses = [Address(country: '', city: '', street1: '', street2: '')];
  List<Skill> selectedSkills = [];

  void addAddress() {
    setState(() {
      addresses.add(Address(country: '', city: '', street1: '', street2: ''));
    });
  }

  void removeAddressAt(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSkills();

    if (widget.initialValues != null) {
      firstNameController.value = TextEditingValue(text: widget.initialValues!.firstName);
      firstNameController.text = widget.initialValues!.firstName;
      lastNameController.value = TextEditingValue(text: widget.initialValues!.lastName);
      lastNameController.text = widget.initialValues!.lastName;

      selectedSkills = widget.initialValues!.skills;
      addresses = widget.initialValues!.addresses;
    }
  }

  Future<void> fetchSkills() async {
    const String url = 'http://localhost:3000/skills';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      setState(() {
        skills = data.map((item) => Skill.fromJson(item)).toList();
      });
    } else {
      throw Exception('error getting skills');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name.';
                    }
                    if (value.length < 2 || value.length > 20) {
                      return 'Names must be between 2 and 20 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name.';
                    }
                    if (value.length < 2 || value.length > 20) {
                      return 'Names must be between 2 and 20 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                MultiSelectDialogField(
                  buttonText: const Text("Choose Student's skills..."),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  searchHint: "Choose Student's skills...",
                  title: const Text("Choose Student's skills"),
                  searchable: true,
                  items: skills.map((skill) => MultiSelectItem(skill, skill.name)).toList(),
                  onConfirm: (values) {
                    selectedSkills = values;
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    return AddressFields(index, addresses, removeAddressAt);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: addAddress, child: const Text('Add Another Address')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var skills = selectedSkills.map((skill) => {'_id': skill.id}).toList();
                      var addressesMap = addresses
                          .map((address) => {
                                'country': address.country,
                                'city': address.city,
                                'street1': address.street1,
                                'street2': address.street2
                              })
                          .toList();

                      var json = jsonEncode({
                        'firstName': firstNameController.text,
                        'lastName': lastNameController.text,
                        'skills': skills,
                        'addresses': addressesMap
                      });

                      widget.onSubmit!(formData: json, context: context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          )),
    );
  }
}

class AddressFields extends StatelessWidget {
  const AddressFields(this.index, this.addresses, this.removeAddressAt, {super.key});

  final int index;
  final List<Address> addresses;
  final void Function(int) removeAddressAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  addresses[index].country = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country.';
                  }
                  if (value.length < 2 || value.length > 20) {
                    return 'Country name must be between 2 and 20 characters.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  addresses[index].city = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city.';
                  }
                  if (value.length < 2 || value.length > 20) {
                    return 'City name must be between 2 and 20 characters.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          onChanged: (value) {
            addresses[index].street1 = value;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Steet1',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your street.';
            }
            if (value.length < 2 || value.length > 20) {
              return 'Street name must be between 2 and 20 characters.';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  addresses[index].street2 = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Steet2',
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            IconButton.filled(
                onPressed: () {
                  removeAddressAt(index);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

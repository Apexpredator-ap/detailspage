import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditDetailsPage extends StatefulWidget {
  final String name;
  final String age;
  final String gender;
  final String phoneNumber;
  final String selectedDate;
  final String address;
  final String email;

  EditDetailsPage({
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.selectedDate,
    required this.address,
    required this.email,
  });

  @override
  _EditDetailsPageState createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController selectedDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  void initState() {
    super.initState();

    nameController.text = widget.name;
    ageController.text = widget.age;
    genderController.text = widget.gender;
    phoneNumberController.text = widget.phoneNumber;
    selectedDateController.text = widget.selectedDate;
    addressController.text = widget.address;
    emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: selectedDateController,
              decoration: InputDecoration(labelText: 'Selected Date'),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Hive.box('DETAIL').put('name', nameController.text);
                Hive.box('DETAIL').put('age', ageController.text);
                Hive.box('DETAIL').put('gender', genderController.text);
                Hive.box('DETAIL')
                    .put('phoneNumber', phoneNumberController.text);
                Hive.box('DETAIL')
                    .put('selectedDate', selectedDateController.text);
                Hive.box('DETAIL').put('address', addressController.text);
                Hive.box('DETAIL').put('email', emailController.text);

                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

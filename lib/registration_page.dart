import 'package:detailspage/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final dateController = TextEditingController();
  final phnController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  DateTime selectDate = DateTime.now();
  final hiveobj = Hive.box('DETAIL');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          "REGISTRATION PAGE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.pink],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Form(
        key: formkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Age",
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || int.tryParse(value) == null) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 20),
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Gender",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: phnController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      labelText: "Phone Number",
                      helperText: 'Enter the existing phone number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Phone number';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Selected Date',
                          suffixIcon: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email id",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: null,
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Address",
                      labelText: "Enter your Address",
                      prefixIcon: Icon(Icons.info_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveDetails(context);

                    // nameController.clear();
                  },
                  child: Text('Save Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectDate) {
      setState(() {
        selectDate = picked;
        dateController.text = "${selectDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void saveDetails(BuildContext context) {
    final valid = formkey.currentState?.validate() ?? false;
    if (valid) {
      hiveobj.put('name', nameController.text);
      hiveobj.put('age', ageController.text);
      hiveobj.put('gender', genderController.text);
      hiveobj.put('phoneNumber', phnController.text);
      hiveobj.put('selectedDate', dateController.text);
      hiveobj.put('address', addressController.text);

      // Navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            name: nameController.text,
            age: ageController.text,
            gender: genderController.text,
            phoneNumber: phnController.text,
            selectedDate: dateController.text,
            address: addressController.text,
            email: emailController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid data')),
      );
    }
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';

import 'editcontroller.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String age;
  final String gender;
  final String phoneNumber;
  final String selectedDate;
  final String address;
  final String email;

  HomePage({
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.selectedDate,
    required this.address,
    required this.email,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final hiveobj = Hive.box('DETAIL');
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final dateController = TextEditingController();
  final phnController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: ${widget.name}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDetailsPage(
                          name: widget.name,
                          age: widget.age,
                          gender: widget.gender,
                          phoneNumber: widget.phoneNumber,
                          selectedDate: widget.selectedDate,
                          address: widget.address,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.edit),
                ),
                ElevatedButton(
                  onPressed: () {
                    _confirmDelete(context);
                  },
                  child: Icon(Icons.delete),
                ),
                ElevatedButton(
                  onPressed: () {},
                  //=>PrintPage(
                  //   name: nameController.text,
                  //   age: ageController.text,
                  //   gender: genderController.text,
                  //   phoneNumber: phnController.text,
                  //   selectedDate: dateController.text,
                  //   address: addressController.text,

                  child: Icon(Icons.print),
                ),
              ],
            ),
            Text('Age: ${widget.age}'),
            Text('Gender: ${widget.gender}'),
            Text('Phone Number: ${widget.phoneNumber}'),
            Text('Selected Date: ${widget.selectedDate}'),
            Text('Address: ${widget.address}'),
            Text('Email: ${widget.email}'),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteEntry(context);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deleteEntry(BuildContext context) {
    hiveobj.delete(widget.name);
    Navigator.pop(context);
  }

  Future<Uint8List> _printDetails(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Name: ${widget.name}'),
              pw.Text('Age: ${widget.age}'),
              pw.Text('Gender: ${widget.gender}'),
              pw.Text('Phone Number: ${widget.phoneNumber}'),
              pw.Text('Selected Date: ${widget.selectedDate}'),
              pw.Text('Address: ${widget.address}'),
              pw.Text('Email: ${widget.email}'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
    return pdf.save();
  }
}

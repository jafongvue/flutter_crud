import 'package:flutter/material.dart';
import 'package:flutter_basic_crud/pages/home.dart';
import 'package:flutter_basic_crud/services/user_services.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String gender = 'Male';
  bool firstnameVal = false;
  bool lastnameVal = false;
  bool birthdayVal = false;
  bool phoneVal = false;
  String? chooseUserType;
  final userType = ['Admin', 'User'];

  DateTime selected = DateTime.now();
  // DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController birthdayController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selected) {
      setState(() {
        selected = picked;
        //birthdayController.text = selected.toString();
        birthdayController.text = formatter.format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              firstnametextfield(context),
              const SizedBox(height: 20),
              lastnametextfield(context),
              const SizedBox(height: 20),
              genderlabel(context),
              genderfield(context),
              const SizedBox(height: 20),
              birthdaytextborder(context),
              const SizedBox(height: 20),
              phonetextborder(context),
              const SizedBox(height: 20),
              selectdropdown(context),
              const SizedBox(
                height: 20,
              ),
              saveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectdropdown(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButton(
            value: chooseUserType,
            isExpanded: true,
            hint: Text('Select'),
            items: userType
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              //chooseUserType = value;
              //print("chooseType:$chooseUserType");
              setState(() {
                chooseUserType = value;
              });
            },
          ),
        ),
        chooseUserType == ""
            ? Container(
                padding: EdgeInsets.only(left: 60),
                child: Row(
                  children: [
                    Text(
                      'please select one!',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  Container genderlabel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          print('firstname: ${firstnameController.text}');
          print('lastname: ${lastnameController.text}');
          print('gender: $gender');
          print('birhtday: ${birthdayController.text}');
          print('phone: ${phonenumberController.text}');
          print('chooseUserType: $chooseUserType');

          if (firstnameController.text.isEmpty) {
            setState(() {
              firstnameVal = true;
            });
            return;
          } else {
            setState(() {
              firstnameVal = false;
            });
          }
          if (lastnameController.text.isEmpty) {
            setState(() {
              lastnameVal = true;
            });
          } else {
            setState(() {
              lastnameVal = false;
            });
          }
          if (birthdayController.text.isEmpty) {
            setState(() {
              birthdayVal = true;
            });
          } else {
            setState(() {
              birthdayVal = false;
            });
          }
          if (phonenumberController.text.isEmpty) {
            setState(() {
              phoneVal = true;
            });
          } else {
            setState(() {
              phoneVal = false;
            });
          }

          var _res = await UserService().createNewUser({
            "firstname": firstnameController.text,
            "lastname": lastnameController.text,
            "gender": gender,
            "birthday": birthdayController.text,
            "role": chooseUserType,
            "phone": phonenumberController.text,
          });
          if (_res == 200) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
                (route) => false);
          }
        },
        child: Text(
          'Save ',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget birthdaytextborder(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 70,
        child: IgnorePointer(
          child: TextFormField(
            controller: birthdayController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Birthday'),
              suffixIcon: Icon(Icons.calendar_month),
              errorText: birthdayVal ? 'please input your birthday' : null,
            ),
          ),
        ),
      ),
    );
  }

  Container phonetextborder(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 70,
      child: TextFormField(
        controller: phonenumberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text('Phone'),
          prefixIcon: Icon(Icons.phone),
          errorText: phoneVal ? 'please enter your phone number' : null,
        ),
      ),
    );
  }

  Widget genderfield(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              Row(
                children: [
                  Radio(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }),
                  Text('Male'),
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }),
                  Text('Female'),
                ],
              )
            ],
          ),
        ),
        gender == ''
            ? Container(
                padding: EdgeInsets.only(left: 60),
                child: Row(
                  children: [
                    Text(
                      'please select gender',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  Container lastnametextfield(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 70,
      child: TextField(
        controller: lastnameController,
        decoration: InputDecoration(
          label: Text('LastName'),
          border: OutlineInputBorder(),
          errorText: lastnameVal ? 'please input your lastname' : null,
        ),
      ),
    );
  }

  Widget firstnametextfield(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 70,
          child: TextField(
            controller: firstnameController,
            decoration: InputDecoration(
              label: Text('FirstName'),
              border: OutlineInputBorder(),
              errorText: firstnameVal ? 'please input your fistname' : null,
            ),
          ),
        ),
        // firstnameController.text.isEmpty
        //     ? Text(
        //         'Please input your firstname',
        //         style: TextStyle(color: Colors.red),
        //       )
        //     : Container()
      ],
    );
  }
}

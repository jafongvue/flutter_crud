import 'package:flutter/material.dart';
import 'package:flutter_basic_crud/pages/add_user.dart';
import 'package:flutter_basic_crud/pages/edit_user.dart';
import 'package:flutter_basic_crud/services/user_services.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userData;
  String? selectedID;

  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    var data = await UserService().getAllUser();
    print("data==>>$data");
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: userData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            userData[index]["gender"] == "Male"
                                ? Image.asset(
                                    'assets/images/man.jpg',
                                    width: 60,
                                  )
                                : Image.asset(
                                    'assets/images/woman.jpg',
                                    width: 60,
                                  ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, //ຕົວໜັງສືເລີ່ມແຕ່ຊ້າຍມາ
                              children: [
                                Text(
                                    '${userData[index]["firstname"]} ${userData[index]["lastname"]}'),
                                Text('${formatter.format(
                                  DateTime.parse(userData[index]["birthDay"] ??
                                      '2022-10-12'),
                                )}'),
                                Text('${userData[index]["role"]}'),
                                Text('${userData[index]["phone"]}'),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUser(
                                      firstname: userData[index]['firstname'],
                                      lastname: userData[index]['lastname'],
                                      gender: userData[index]['gender'],
                                      birthday: userData[index]['birthday'],
                                      phone: userData[index]['phone'],
                                      role: userData[index]['role'],
                                      id: userData[index]['_id'],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                selectedID = userData[index]['_id'];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete?'),
                                    content: Text('Do you want to delete!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          var _res = await UserService()
                                              .deleteUser(selectedID);
                                          if (_res == 200) {
                                            var user = await UserService()
                                                .getAllUser();
                                            setState(() {
                                              userData = user;
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
    );
  }
}

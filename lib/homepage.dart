import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseaut/updatepage.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map> data = [];
  TextEditingController edit = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewdatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onLongPress: () {
                    final title = data[index]['fname'];
                    myshowdialogue(title, data[index]['id']);
                  },
                  title: Container(
                    height: 50,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("${data[index]['fname']}"),
                        Text("${data[index]['lname']}"),
                        Text("Long press to update")
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("${data[index]['image']}"),
                  ),
                  onTap: () {

                  });
            },
          ),
          Text("Update here"),
        ],
      ),
    );
  }

  Future<void> viewdatabase() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("realtimekrince");
    DatabaseEvent dt = await ref.once();

    Map map = dt.snapshot.value as Map;
    map['key'] = dt.snapshot.key;

    map.forEach((key, value) {
      data.add(value);
    });
  }

  Future<void> myshowdialogue(String title, String id) async {
    edit.text = title;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Update"),
                        content: Container(
                          child: TextField(
                            controller: edit,
                            decoration: InputDecoration(
                                hintText: "Edit"),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                DatabaseReference ref = FirebaseDatabase
                                    .instance.ref("realtimekrince");
                                ref.child(id).update({
                                  'fname': edit.text
                                }).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Update succesfully")));
                                });
                              },
                              child: Text("update")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("cancel"))
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {

                  Navigator.pop(context);
                  DatabaseReference ref = FirebaseDatabase.instance.ref("realtimekrince");
                  ref.child(id).remove();

                }, icon: Icon(Icons.delete))
          ],
        );
      },
    );
  }

}

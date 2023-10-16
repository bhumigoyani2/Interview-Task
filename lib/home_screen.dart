import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:interview_task/details_screen.dart';
import 'package:interview_task/login_screen.dart';

import 'login_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List itemList = [];
  Map product = {};
  bool get = false;
  final LoginController _loginController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
    productApi();
  }

  void _logout() {
    _loginController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialog(barrierDismissible: false,context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text("LogOut"),
                    content: const Text("Are sure want to logout?"),
                    actions: [
                      TextButton(onPressed: (){
                        _logout();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                      }, child: const Text("Yes")),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text("No"))
                    ],
                  );
                },);
              },
              child: const Text("LogOut"))
        ],
      ),
      body: get == true
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Image.network(
                      "${product['image']}",
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width - 130, top: 20),
                  child: const Text("New Arrivals",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: itemList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 380),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  height: 200,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.pink.shade50)),
                              Image.network(
                                "${itemList[index]['image']}",
                                height: 100,
                              ),
                              Positioned(
                                bottom: 20,
                                right: 5,
                                child: Hero(
                                  tag: 'no $index',
                                  child: ElevatedButton(
                                    onPressed: () {
                                      timeDilation = 10.0;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsScreen(
                                                itemList: itemList[index]),
                                          ));
                                    },
                                    style: const ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                          CircleBorder(),
                                        ),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black)),
                                    child: const Icon(Icons.add,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                "${itemList[index]['title']}\n\n\$${itemList[index]['price']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }

  void getApi() async {
    get = true;
    setState(() {});
    try {
      http.Response response =
          await http.get(Uri.parse("https://fakestoreapi.com/products"));
      if (response.statusCode == 200) {
        itemList = jsonDecode(response.body);
        itemList.shuffle();
        Fluttertoast.showToast(
            msg: "Get data successfully..!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (s, e) {
      debugPrint("$s");
      debugPrint("$e");
    }
    get = false;
    setState(() {});
  }

  void productApi() async {
    get = true;
    setState(() {});
    try {
      http.Response response =
          await http.get(Uri.parse("https://fakestoreapi.com/products/1"));
      if (response.statusCode == 200) {
        product = jsonDecode(response.body);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (s, e) {
      debugPrint("$s");
      debugPrint("$e");
    }
    get = false;
    setState(() {});
  }
}

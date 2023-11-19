import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:untitled/recipe/Model.dart';
import 'package:untitled/recipe/Webview.dart';

class Search extends StatefulWidget {
  String query;
  Search(this.query);
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  @override
  bool isLoading = true;
  List<RecipeModel> recipelist = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=8835fe0b&app_key=669fae2eef2bf88d06a490b99996c17e";
    var Response = await http.get(Uri.parse(url));
    Map data = jsonDecode(Response.body);
    //log((data).toString());

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      log((recipelist).toString());
    });
    recipelist.forEach((Recipe) {
      print(Recipe.app_label);
      print(Recipe.app_calories);
      print(Recipe.app_img_uri);
      print(Recipe.app_url);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe(widget.query);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)])),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  //Search Wala Container

                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchController.text).replaceAll(" ", "") ==
                              "") {
                            print("Blank search");
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Search(searchController.text)));
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Let's Cook Something!"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipelist.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            webop(recipelist[index].app_url)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0.0,
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      recipelist[index].app_img_uri,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                          ),
                                          child: Text(
                                            recipelist[index].app_label,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                  Positioned(
                                      right: 0.0,
                                      height: 40,
                                      width: 80,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            )),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 20,
                                            ),
                                            Text(
                                              (recipelist[index]
                                                      .app_calories
                                                      .toString())
                                                  .substring(0, 6),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )),
                                ]),
                              ),
                            );
                          })),
            ],
          ),
        )
      ]),
    );
  }
}

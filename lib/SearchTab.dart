import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  final String title;

  SearchTab({Key key, this.title}) : super(key: key);
  String searchText = "";
  Text text;
  var categories = [Text("some"), Text("some"), Text("some")];
  final items = List<String>.generate(10000, (i) => "Item $i");

  @override
  SearchTabState createState() => new SearchTabState();

}

class SearchTabState extends State<SearchTab> {
  TextEditingController editingController = new TextEditingController();

  final defaultList = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(defaultList);
    super.initState();
  }


  void filterSearchResults(String query){
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(defaultList);
    if(query.isNotEmpty){
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item){
        if(item.contains(query)){
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(defaultList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.topCenter,
              child: TextField(
                cursorColor: Colors.red,
                cursorWidth: 2.0,
                keyboardType: TextInputType.multiline ,
                maxLines: null,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 8.0,bottom: 8.0, left: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22.0))
                    ),
                    hintText: "Search",
                    labelText: "Search",
                    hintStyle: TextStyle(),
                    prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
            Expanded(
              child:ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(items[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.black);
                },
              ),
            )
          ],
        ),
      ),
    );
  }





}






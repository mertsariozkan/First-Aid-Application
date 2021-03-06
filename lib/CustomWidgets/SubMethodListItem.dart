import 'package:flutter/material.dart';
import '../MethodPage.dart';
import 'package:firstaidproject/DatabaseHelper.dart';

class SubMethodListItem extends StatefulWidget {
  String categoryName;
  List favList;
  bool isFav;
  String baseCategory;

  SubMethodListItem(String categoryName,List favList,bool isFav,  String baseCategory) {
    this.categoryName = categoryName;
    this.favList = favList;
    this.isFav = isFav;
    this.baseCategory = baseCategory;
  }

  String getCategoryName() {
    return categoryName;
  }

  String getBaseCategoryName() {
    return baseCategory;
  }

  @override
  State<StatefulWidget> createState() {
    return _SubMethodListItemState(categoryName,favList,isFav,baseCategory);
  }
}



class _SubMethodListItemState extends State<SubMethodListItem> {

  var _favIcon;
  String categoryName;
  List favList;
  bool isFav;
  String baseCategory;

  final dbHelper = DatabaseHelper.instance;

  _SubMethodListItemState(String categoryName, List favList,bool isFav,  String baseCategory) {
    this.baseCategory = baseCategory;
    this.categoryName = categoryName;
    this.favList = favList;
    if(favList.indexWhere((subListItem) => subListItem.categoryName.startsWith(categoryName))==-1) {
      this.isFav = false;
      _favIcon = Icons.star_border;
    } else {
      this.isFav = true;
      _favIcon = Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          splashColor: Color.fromRGBO(255, 81, 81, 0),
          highlightColor: Colors.red,
          onTap: () => _onClickItem(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 0.0, bottom: 0.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(Icons.local_hospital),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(categoryName,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.4)),
                  )
                ]),
                IconButton(
                  color: Colors.red,
                  onPressed: _onClickFavIcon,
                  icon: Icon(_favIcon),
                  padding: EdgeInsets.all(0),
                )
              ],
            ),
          ),
        ),
        /*Divider(
              color: Colors.black,

          )*/
      ],
    );
  }

  void _insert(String name, String baseName) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.baseColumnName: baseName
    };

    await dbHelper.insert(row);
  }

  void _delete(String name) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name
    };

    await dbHelper.delete(name);
  }


  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => print(row));
  }

  void _onClickItem(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MethodPage(categoryName,baseCategory)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onClickFavIcon() {
    setState(() {
      if(_favIcon==Icons.star_border) {
        _favIcon = Icons.star;
        isFav = true;
        favList.add(SubMethodListItem(categoryName,favList,isFav,baseCategory));
      } else {
        _favIcon = Icons.star_border;
        isFav = false;
        favList.removeAt(favList.indexWhere((subListItem) => subListItem.categoryName.startsWith(categoryName)));
      }

    });
    if(!isFav){
      print("remove : " + categoryName);
      _delete(categoryName);
      // TODO: Means that user wants to remove the item from favourites (which is again the persistent data on user's phone.)
    }
    else if(isFav){
      print("add : " + categoryName);
      _insert(categoryName,baseCategory);
      // TODO: Add to favourites tab list. (which is a persistent data on user's phones)
    }
  }
}

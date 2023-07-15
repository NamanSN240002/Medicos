import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  Map data = {};
  _launchURLBrowser(url) async {
    launchUrl(url);
  }
  Widget makeCard(row){
    return TextButton(
      onPressed: (){
        _launchURLBrowser(Uri.parse(row['url']));
      },
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: const BoxDecoration(
                    border:  Border(
                        right:  BorderSide(width: 1.0, color: Colors.white24))),
                child:const Icon(Icons.local_hospital_rounded, color: Colors.white),
              ),
              title: Text(
                row['name'],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text("Ratings: ", style: TextStyle(color: Colors.white)),
                      Text(row['rating'], style: TextStyle(color: Colors.white)),
                      Icon(Icons.star,color: Colors.white,size: 18,)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Number of users rated: ", style: TextStyle(color: Colors.white)),
                      Text(row['user_ratings_total'], style: TextStyle(color: Colors.white)),
                      Icon(Icons.reviews,color: Colors.white,size: 18,)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Vicinity: ", style: TextStyle(color: Colors.white),softWrap: true),
                      Expanded(child: Text(row['vicinity'], style: TextStyle(color: Colors.white),softWrap: true,)),
                      Icon(Icons.location_history,color: Colors.white,size: 18,)
                    ],
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data =  ModalRoute.of(context)!.settings.arguments as Map;
    var list = data['docList'];
    var diagnosis = data['diagnosis'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby doctors for \n$diagnosis:"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(list[index]);
              },
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:medicos/services/form_service.dart';

class MediForm extends StatefulWidget {
  const MediForm({super.key});

  @override
  State<MediForm> createState() => _MediFormState();
}

class _MediFormState extends State<MediForm> {
  Map data = {};
  Map<dynamic,dynamic> user={};
  List<String> symptoms=[];
  List<String> searchSym = [];
  List<String> _selectedItems = [];
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    data =  ModalRoute.of(context)!.settings.arguments as Map;
    user = data['user'];
    var list = data['symptoms'];
    list.forEach((element)=>{
      symptoms.add(element)
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Diagnosis Form"),
            ElevatedButton(
              onPressed: () async{
                Prediction instance = Prediction(symptoms: _selectedItems);
                await instance.get_diagnosis();
                String diagnosis = instance.diagnosis_result['final_prediction'];
                Navigator.pushNamed(context, '/loader',arguments: {
                  'diagnosis':diagnosis,
                  'user':user
                });
              },
              style:ElevatedButton.styleFrom(
                primary: Colors.redAccent.shade100
              ),
              child: Text(
                "Submit Form",
              ),
            ),
          ],
        ),
      ),
      body:Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    searchSym = symptoms
                        .where((item) => item.toLowerCase().contains(value.toLowerCase()))
                        .toSet().toList();

                  });
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search Symptoms",
                  hintText: "Type symptom name",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchSym.length,
                itemBuilder: (context, index)=> Container(
                  color: (_selectedItems.contains(searchSym[index]))
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.grey.shade300, // this is the container's color
                        boxShadow:const  [
                          BoxShadow(), // no shadow color set, defaults to black
                        ]
                    ),
                    child: ListTile(
                      onTap: () {
                        if (_selectedItems.contains(searchSym[index])) {
                          setState(
                                  () => _selectedItems.removeWhere((val) => val == searchSym[index]));
                        }
                      },
                      onLongPress: () {
                        if (!_selectedItems.contains(searchSym[index])) {
                          setState(() => _selectedItems.add(searchSym[index]));
                        }
                      },
                      title: Text(
                          searchSym[index]
                      ),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

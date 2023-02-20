import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

class Filter extends StatefulWidget {
  @override
  const Filter({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool loading = true;

  final List<String> claim_states = ['Pending', 'Approve', 'Reject'];

  // form values
  late String currentState;


  void initFilter() async {
    final preference = await SharedPreferences.getInstance();
    currentState =  preference.getString('claim_state')!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initFilter();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Update view claim filter settings'),
              backgroundColor: const Color.fromARGB(255, 105, 184, 109),
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric( vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40.0),
                       const SizedBox(height: 1.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 5.0),
                            const SizedBox(height: 4.0),
                      DropdownButtonFormField(
                        value: currentState,
                        decoration: textInputDecoration,
                        items: claim_states.map((claim_state_option) {
                          return DropdownMenuItem(
                            value: claim_state_option,
                            child: Text(claim_state_option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentState = newValue!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 20.0),

 ElevatedButton(
                             child: const Text('Set Filtering'),
                             style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize: 15),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 50.0),
                            ), onPressed: () async {
                            if (_formKey.currentState != null &&  _formKey.currentState!.validate()) {
                              final preference = await SharedPreferences.getInstance();
                              await preference.setString("claim_state", currentState);
                              Navigator.pop(context, true);

                            }
                          }),

                    ],
                  ),
                )
          ),
          );
  }
}

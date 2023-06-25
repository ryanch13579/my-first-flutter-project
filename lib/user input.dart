import 'package:flutter/material.dart';
import 'timer3.dart';
// ignore: unused_import
import 'package:animated_snack_bar/animated_snack_bar.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String _work = "";
  String _rest = "";
  String _rounds = "";

  TextEditingController _workController = TextEditingController();
  TextEditingController _restController = TextEditingController();
  TextEditingController _sessionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildWork() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: _workController,
        decoration: const InputDecoration(
          errorStyle: TextStyle(fontSize: 25),
          labelText: 'Work',
          hintText: 'Workout Duration in Seconds',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 25),
        ),
        style: TextStyle(fontSize: 26),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid work duration';
          }
          int work = int.parse(value);
          if (work == null || work <= 0) {
            return 'Work must be a positive number';
          }

          if (work < 5) {
            return 'Work must be 5 or more';
          }

          if (work == 69 || work == 420) {
            return 'Nice ;-)';
          }
          return null;
        },
        onSaved: (value) {
          _work = value!;
        },
      ),
    );
  }

  Widget _buildRest() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        controller: _restController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 25),
          labelText: 'Rest',
          hintText: 'Rest Duration in Seconds',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 25),
        ),
        style: TextStyle(fontSize: 30, fontFamily: 'Arial'),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid rest duration';
          }
          int rest = int.parse(value);
          if (rest == null || rest <= 0) {
            return 'Rest must be a positive number';
          }
          if (rest < 5) {
            return 'Rest must be 5 or more';
          }
          if (rest == 69 || rest == 420) {
            return 'Nice ;-)';
          }
          return null;
        },
        onSaved: (value) {
          _rest = value!;
        },
      ),
    );
  }

  Widget _buildRounds() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        controller: _sessionController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 25),
          labelText: 'Rounds',
          hintText: 'Number of Rounds',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 25),
        ),
        style: TextStyle(fontSize: 30),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid number of rounds';
          }
          int rounds = int.parse(value);
          if (rounds == null || rounds <= 0) {
            return 'Rounds must be a positive number';
          }
          if (rounds == 69 || rounds == 420) {
            return 'Nice ;-)';
          }
          return null;
        },
        onSaved: (value) {
          _rounds = value!;
        },
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          height: 100,
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              const Icon(Icons.close, color: Colors.white, size: 45),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Error Occurred',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white,
                      height: 3,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your Input Are Incorrect',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.only(bottom: 90),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 54, 233, 239),
            Color.fromARGB(255, 67, 64, 251),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 10),
                _buildWork(),
                SizedBox(height: 2),
                _buildRest(),
                SizedBox(height: 2),
                _buildRounds(),
                SizedBox(
                  height: 2,
                ),
                ElevatedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(350, 80),
                      backgroundColor: Colors.deepOrangeAccent),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PomodoroTimer(
                            breakTime: _restController.text,
                            workTime: _workController.text,
                            sessionTime: _sessionController.text,
                          ),
                        ),
                      );
                    } else {
                      _showErrorSnackbar(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

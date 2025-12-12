import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _formKey=GlobalKey<FormState>();

  var _isLogin=true;
  var _enteredEmail='';
  var _enteredPassword='';
  File? _selectedImage;
  var _isAuthenticating=false;
  var _enteredUsername='';

  void _submit() async {
    final isValid=_formKey.currentState!.validate();

    if(!isValid || !_isLogin && _selectedImage==null){
      return;
    }
    
    _formKey.currentState!.save();

    try{
      setState(() {       //in order to close the circular progress indicator
        _isAuthenticating=true;
      });

      if(_isLogin){
          final userCredentials=await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, 
          password: _enteredPassword,
        );
      } else {
        
            final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, 
            password:  _enteredPassword,
          );

          final storageRef=FirebaseStorage.instance.ref()   //firebase cloud storage reference, child() to get a path into the bucket of that storage
            .child('user_images')                  
            .child('${userCredentials.user!.uid}.jpg');   //userCredentials.user gives us access to some user data that was created here
          await storageRef.putFile(_selectedImage!);
          final imageurl=await storageRef.getDownloadURL();   //to display the image stored on firebase 
          
          await FirebaseFirestore.instance.collection('users')
          .doc(userCredentials.user!.uid) //of the particular user id that is stored 
          .set({
            'username' : _enteredUsername,
            'email': _enteredEmail,
            'image_url': imageurl
          });
        }                   
    }
      on FirebaseAuthException catch(error){      //on=type of exception
        if(error.code =='email already in use'){}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? 'Authentication Failed.'),
          ),
        ); 
        setState(() {            //in order to close the circular progress indicator 
          _isAuthenticating=false;
        });
      }
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 78, 137, 136),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat_green.jpg'),
              ),
              Card(
                margin: EdgeInsets.all(20),  //to add a margin of 20 at all (top,bottom,left,right)
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,  //means that its content can take as much size as their content need
                        children: [
                          if(!_isLogin) UserImagePicker(
                            onPickImage: (pickedImage){
                              _selectedImage=pickedImage;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address'
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false, 
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value==null || value.trim().isEmpty || !value.contains('@')){
                                return 'Please enter a valid email address';
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail=value!;
                            },
                          ),
                          if(!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if(value==null || value.isEmpty || value.trim().length<4){
                                  return 'Please enter atleast 4 characters';
                                }
                                return null;
                              },
                              onSaved: (value){
                                _enteredUsername=value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password'
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,    //hides the characters while entering password
                            validator: (value){
                              if(value==null || value.trim().length<6){
                                return 'Password must be atleast 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword=value!;
                            }
                          ),
                          const SizedBox(height: 12),
                          if(_isAuthenticating)
                            const CircularProgressIndicator(),
                          if(!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 144, 191, 181)
                              ),
                              child: Text(_isLogin ? 'login' : 'Sign Up'),
                            ),
                          if(!_isAuthenticating)
                            TextButton(        //allows users to switch between login and sign up
                              onPressed: () {
                                setState(() {
                                  _isLogin=!_isLogin;     //This means: “Right now you’re in Login mode. Click this button if you want to switch to Signup mode.”
                                });
                              }, 
                              child: Text(_isLogin ? 'Create An Account' : 'Already Have An Account.'),
                            ),
                        ],
                      )
                    ),
                  ),
                ),
              )
             ],
          ),
        ),
      ),
    );
  }
}
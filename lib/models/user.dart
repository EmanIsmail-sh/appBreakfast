
import 'package:flutter/foundation.dart';

class User {
   String name;
   String email;
   String password;
   String password_confirmation;
   String phone;
   String gender;
   String date_of_birth;
   String address;
   int country_id;
  User({
    @required this.name,
    @required this.email,
    this.gender,
    this.phone,
    this.address,
    this.date_of_birth,
    this.country_id,
    @required this.password,
    @required this.password_confirmation
  });

     Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
        'phone': phone,
        'gender' : gender,
        'date_of_birth': date_of_birth,
        'address': address,
        'country_id': country_id.toString()
       
      };
      
}


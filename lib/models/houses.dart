import 'package:flutter/cupertino.dart';

import 'user.dart';


class Houses{
  final User landlord;
  final int houseID;
  final String houseName;
  final String houseAddress;
  final String houseDescription;
  final int price;
  final String housePic;
  final List<String> housePics;
  final int vacancies;
  final List requests;
  final List<String> tags;

  Houses({
    @required this.landlord, 
    @required this.houseID, 
    @required this.houseName, 
    @required this.houseAddress, 
    @required this.price,
    @required this.vacancies, 
    this.houseDescription,
    this.housePic = 'assets/images/home-default.png',
    this.housePics, 
    this.requests,
    this.tags,
  });
}
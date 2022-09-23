import 'package:flutter/material.dart';

Widget customDropDown(
List<String> items,
String value,
void onChange (val)
){
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButton<String>(
      value:  value,
      onChanged: ( val){
        onChange(val);
      },
      items: items.map<DropdownMenuItem<String>>((e){
        return DropdownMenuItem(child:Text(e),
          value: e,
        );
      }).toList(),
    ),
  );
}
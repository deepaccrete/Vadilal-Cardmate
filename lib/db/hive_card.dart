import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class HiveBoxes{
  static Box<CardDetails>? _box;
  static const _boxName = 'cardbox';

  static Future<Box<CardDetails>> getCard() async{
    if(_box == null || !_box!.isOpen){
      try{
        _box = await Hive.openBox<CardDetails>(_boxName);
      }catch(e){
        print("Error opening  '$_boxName'Hive Box: $e" );
        rethrow;
      }
    }
    if(_box ==null){
      throw HiveError("Hive box '$_boxName' could not be opened");
    }
    return _box!;
  }

  static Future<void> addCard(CardDetails carddetailas)async{
    final box = await getCard();

    await box.put(carddetailas.id, carddetailas);
  }

  static Future<void> updateCard(CardDetails carddetails)async{
    final box = await getCard();
    await box.put(carddetails.id, carddetails);
  }

  static Future<void> deleteCard(CardDetails carddetails)async{
    final box = await getCard();
    await box.delete(carddetails.id,);
  }

  static Future<List<CardDetails>> getAllCard()async{
    final box = await getCard();
    return box.values.toList();
  }





}
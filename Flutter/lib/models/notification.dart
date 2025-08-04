import 'package:flutter/material.dart';

class MaintenanceNotification {
  final String qmnum;
  final String iwerk;
  final String iloAn;
  final String equnr;
  final String ingrp;
  final String ausvn;
  final String qmart;
  final String auszt;
  final String artyp;
  final String qmtxt;
  final String prioK;
  final String arbplwerk;
  final String status;

  MaintenanceNotification({
    required this.qmnum,
    required this.iwerk,
    required this.iloAn,
    required this.equnr,
    required this.ingrp,
    required this.ausvn,
    required this.qmart,
    required this.auszt,
    required this.artyp,
    required this.qmtxt,
    required this.prioK,
    required this.arbplwerk,
    required this.status,
  });

  factory MaintenanceNotification.fromJson(Map<String, dynamic> json) {
    return MaintenanceNotification(
      qmnum: json['Qmnum'] ?? '',
      iwerk: json['Iwerk'] ?? '',
      iloAn: json['IloAn'] ?? '',
      equnr: json['Equnr'] ?? '',
      ingrp: json['Ingrp'] ?? '',
      ausvn: json['Ausvn'] ?? '',
      qmart: json['Qmart'] ?? '',
      auszt: json['Auszt'] ?? '',
      artyp: json['Artyp'] ?? '',
      qmtxt: json['Qmtxt'] ?? '',
      prioK: json['PrioK'] ?? '',
      arbplwerk: json['Arbplwerk'] ?? '',
      status: json['Status'] ?? '',
    );
  }

  String get priorityText {
    switch (prioK) {
      case '1':
        return 'High';
      case '2':
        return 'Medium';
      case '3':
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  Color get priorityColor {
    switch (prioK) {
      case '1':
        return Colors.red;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
} 
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

  String get formattedDate {
    try {
      if (ausvn.isEmpty) return '';
      // Handle /Date(XXXXXXXXXXXX)/ format
      final regex = RegExp(r"/Date\((\d+)\)/");
      final match = regex.firstMatch(ausvn);
      if (match != null) {
        final millis = int.parse(match.group(1)!);
        final date = DateTime.fromMillisecondsSinceEpoch(millis);
        return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      }
      // Try parsing as yyyy-MM-dd or yyyyMMdd
      DateTime date;
      if (ausvn.contains('-')) {
        date = DateTime.parse(ausvn);
      } else if (ausvn.length == 8) {
        date = DateTime.parse(ausvn.substring(0,4)+'-'+ausvn.substring(4,6)+'-'+ausvn.substring(6,8));
      } else {
        return ausvn;
      }
      return '${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}';
    } catch (_) {
      return ausvn;
    }
  }

  String get formattedTime {
    try {
      if (auszt.isEmpty) return '';
      // Try parsing as HH:mm:ss or HHmmss
      if (auszt.contains(':')) {
        final parts = auszt.split(':');
        return '${parts[0].padLeft(2,'0')}:${parts[1].padLeft(2,'0')}';
      } else if (auszt.length == 6) {
        return '${auszt.substring(0,2)}:${auszt.substring(2,4)}';
      } else {
        return auszt;
      }
    } catch (_) {
      return auszt;
    }
  }
} 
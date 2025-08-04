class WorkOrder {
  final String aufnr;
  final String qmtxt;
  final String autyp;
  final String bukrs;
  final String sworK;
  final String werks;
  final String ktext;
  final String kostl;
  final String ltxa1;

  WorkOrder({
    required this.aufnr,
    required this.qmtxt,
    required this.autyp,
    required this.bukrs,
    required this.sworK,
    required this.werks,
    required this.ktext,
    required this.kostl,
    required this.ltxa1,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      aufnr: json['Aufnr'] ?? '',
      qmtxt: json['Qmtxt'] ?? '',
      autyp: json['Autyp'] ?? '',
      bukrs: json['Bukrs'] ?? '',
      sworK: json['SworK'] ?? '',
      werks: json['Werks'] ?? '',
      ktext: json['Ktext'] ?? '',
      kostl: json['Kostl'] ?? '',
      ltxa1: json['Ltxa1'] ?? '',
    );
  }

  String get workOrderType {
    switch (autyp) {
      case 'PM01':
        return 'Preventive Maintenance';
      case 'PM02':
        return 'Corrective Maintenance';
      case 'PM03':
        return 'Emergency Maintenance';
      default:
        return 'Other';
    }
  }
} 
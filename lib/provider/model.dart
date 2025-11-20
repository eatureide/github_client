class GeocodeItem {
  final String formattedAddress;
  final double latitude;
  final double longitude;

  GeocodeItem({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  // 从 Map<String, dynamic>（也就是您的 Map 结果）构建 Model
  factory GeocodeItem.fromMap(Map<String, dynamic> map) {
    // 安全地将字符串转换为 double
    return GeocodeItem(
      formattedAddress: map['formattedAddress'] as String,
      latitude: double.tryParse(map['latitude'] as String) ?? 0.0,
      longitude: double.tryParse(map['longitude'] as String) ?? 0.0,
    );
  }
}

class Time {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final String weekday;
  final String miniMonth;

  Time({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.millisecond,
    required this.weekday,
    required this.miniMonth,
  });
}

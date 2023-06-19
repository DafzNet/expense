class Month{

  Month();

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String get currentMonth {
    return months[DateTime.now().month-1];
  }

  String getMonth(int month) {
    return months[DateTime.now().month-1];
  }

  int get currentMonthNumber {
    return DateTime.now().month;
  }

}
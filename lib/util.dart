


class Util {
  static Map<String,String> list = null;
  static Map<String,String> listDes = null;

  static  String twoNumber(int number) {
    String str = number.toString();
    if(str.length > 1) {
      return str;
    }
    return "0"+str;
  }

  static String getIconLocal(String icon) {
    if(list == null) {
      list = new Map<String,String>();
      list['01d'] = "day_clear";
      list['02d'] = "day_partial_cloud";
      list['03d'] = "cloudy";
      list['04d'] = "angry_clouds";
      list['09d'] = "rain";
      list['10d'] = "day_rain_thunder";
      list['11d'] = "rain_thunder";
      list['13d'] = "snow";
      list['50d'] = "mist";


      list['01n'] = "night_full_moon_clear";
      list['02n'] = "night_full_moon_partial_cloud";
      list['03n'] = "cloudy";
      list['04n'] = "angry_clouds";
      list['09n'] = "rain";
      list['10n'] = "night_full_moon_rain_thunder";
      list['11n'] = "rain_thunder";
      list['13n'] = "snow";
      list['50n'] = "mist";
    }
    return list[icon];
  }

  static String getDescription(String description) {
    if(listDes == null) {
      listDes = new Map<String,String>();
      listDes['light rain'] = "mưa nhỏ";
      listDes['moderate rain'] = "mưa vừa";
      listDes["overcast clouds"] = "mây u ám";
      listDes["broken clouds"] = "những đám mây vỡ";
      listDes['heavy intensity rain'] = "mưa cường độ lớn";

    }
    if(!listDes.containsKey(description)) {
      return "";
    }
    return listDes[description];
  }

  static String dateNow() {
    DateTime date = DateTime.now();
    return  Util.twoNumber(date.day)+"/"+ Util.twoNumber(date.month);
  } 

  static String convertTempKtoC(double temp) {
    return  formatDouble(temp - 273.15);
  } 

  static String formatDouble(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }
}
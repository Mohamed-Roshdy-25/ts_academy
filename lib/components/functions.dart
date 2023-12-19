import 'package:ts_academy/constants/constants.dart';

String formatTimeDifference(DateTime postDate) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(postDate);

  if (difference.inSeconds < 60) {
    if(local == "ar"){
      return 'منذ ${difference.inSeconds} ثانية';
    }else{
      return '${difference.inSeconds} sec';
    }
  } else if (difference.inMinutes < 60) {
    if(local == "ar"){
      return 'منذ ${difference.inMinutes} دقيقة';
    }else{
      return '${difference.inMinutes} min';
    }
  } else if (difference.inHours < 24) {
    if(local == "ar"){
      return 'منذ ${difference.inHours} ساعات';
    }else{
      return '${difference.inHours} hour';
    }
  } else if (difference.inDays == 1) {
    if(local == "ar"){
      return 'منذ يوم';
    }else{
      return '1 day';
    }
  } else if (difference.inDays == 2) {
    if(local == "ar"){
      return 'منذ يومين';
    }else{
      return '2 days';
    }
  } else if (difference.inDays < 7) {
    if(local == "ar"){
      return 'منذ ${difference.inDays} أيام';
    }else{
      return '${difference.inDays} days';
    }
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    if (weeks == 1) {
      if(local == "ar"){
        return 'منذ أسبوع';
      }else{
        return '1 week';
      }
    } else if (weeks == 2) {
      if(local == "ar"){
        return 'منذ أسبوعين';
      }else{
        return '2 weeks';
      }
    } else {
      if(local == "ar"){
        return 'منذ $weeks أسابيع';
      }else{
        return '$weeks weeks';
      }
    }
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    if (months == 1) {
      if(local == "ar"){
        return 'منذ شهر';
      }else{
        return '1 month';
      }
    } else if (months == 2) {
      if(local == "ar"){
        return 'منذ شهرين';
      }else{
        return '2 month';
      }
    } else {
      if(local == "ar"){
        return 'منذ $months أشهر';
      }else{
        return '$months month';
      }
    }
  } else {
    int years = (difference.inDays / 365).floor();
    if (years == 1) {
      if(local == "ar"){
        return 'منذ سنة';
      }else{
        return '1 year';
      }
    } else if (years == 2) {
      if(local == "ar"){
        return 'منذ سنتين';
      }else{
        return '2 year';
      }
    } else {
      if(local == "ar"){
        return 'منذ $years سنوات';
      }else{
        return '$years years';
      }

    }
  }
}
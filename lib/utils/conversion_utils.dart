import 'package:intl/intl.dart';

class Util {
  String formatDate(DateTime timeStamp) =>
      DateFormat('E, dd MMM yyyy, hh:mm a').format(timeStamp);

// T convertType<dyanmic>(Map<String , dynamic> data){
  //   if(T == NotificationModel){
  //     return NotificationModel.fromMap(data) as T;
  //   }
  //   else if(T == AnnouncementModel) {
  //     return AnnouncementModel.fromMap(data) as  T;
  //   }else{
  //     dev.log("Unsupported Type $T");
  //     throw Exception("Unsupported Type $T ");
  //   }
  // }
}
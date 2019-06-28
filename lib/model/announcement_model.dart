import 'package:ai_life/remote/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'base_response.dart';

const List<Color> colors = const [
  Colors.purple,
  Colors.lightBlue,
  const Color(0xFFF57C00),
  const Color(0xFF558B2F),
  const Color(0xFFBF360C),
];

class AnnouncementModel extends ChangeNotifier {
  List<AnnouncementType> _announcementTypes;

  set announcementTypes(newValue) {
    if (_announcementTypes == newValue) {
      return;
    }
    _announcementTypes = newValue;
    notifyListeners();
  }

  List<Announcement> _announcementList;

  set announcementList(newValue) {
    if (listEquals(_announcementList, newValue)) {
      return;
    }
    _announcementList = newValue;
    notifyListeners();
  }

  AnnouncementModel() {
    _getAllAnnouncement();
  }

  void _getAllAnnouncement() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Api.getAnnounceTypes().then((resp) {
        if (resp.success) {
          announcementTypes = resp.data;
        }
        return Api.getAnnouncements(typesString);
      }).then((resp) {
        if (resp.success) {
          announcementList = resp.data;
        }
      });
    });
  }

  String get typesString =>
      _announcementTypes?.map((e) => e?.typeId)?.toList()?.join(",") ?? "";

  List<Announcement> get announcements => _announcementList ?? [];

  List<AnnouncementType> get announcementTypes => _announcementTypes ?? [];

  String typeTitle(int index) {
    return announcementTypes.firstWhere((type) {
          return type.typeId == announcements[index].noticeType;
        }, orElse: () => null)?.typeName ??
        "";
  }

  String title(int index) {
    return announcements[index].noticeTitle;
  }

  Color bannerColor(int index) {
    return colors[announcements[index].noticeType % (colors.length)];
  }
}

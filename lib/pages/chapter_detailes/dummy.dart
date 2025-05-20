

import 'package:grip/pages/chapter_detailes/membermodel.dart';

List<MemberModel> get headMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "PRESIDENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "VICE PRESIDENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "TREASURER"),
      ];

  List<MemberModel> get coreCommitteeMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN REFERRAL"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN ONE TO ONE"),
        MemberModel("R. Dinesh", "Marvel Interiors", "CHAIRMAN VISITORS",
            isHighlighted: true),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN ATTENDANCE"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN EVENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN BUSINESS",
            isHighlighted: true),
        MemberModel("S.Kiran", "Krishna Electrical", "PUBLIC IMAGE",
            isHighlighted: true),
      ];

  List<MemberModel> get allMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9845225616"),
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9343526910"),
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9652435616"),
      ];

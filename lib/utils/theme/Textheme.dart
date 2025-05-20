import 'package:flutter/material.dart';
import 'package:grip/utils/constants/Tcolors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class TTextStyles {
  TTextStyles._();
  static final TextStyle onboradtitle = GoogleFonts.roboto(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle onboradsubtitle = GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle usernametitle = GoogleFonts.roboto(
    fontSize: 20.0.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle usersubtitle = GoogleFonts.roboto(
    fontSize: 14.0.sp,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static final TextStyle slidertitle = GoogleFonts.roboto(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle sildersubtitle = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle cardtitle = GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle title = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle redtitle = GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Tcolors.head_title_color,
  );
  static final TextStyle resoption = GoogleFonts.roboto(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle bodycontentsmall = GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static final TextStyle bodycontentmediam = GoogleFonts.roboto(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static final TextStyle customcard = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static final TextStyle profiledes = GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static final TextStyle profiledetails = GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static final TextStyle myprofile = GoogleFonts.roboto(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: Color(0xFFC83837),
  );
  static final TextStyle Editprofile = GoogleFonts.roboto(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Color(0xFFC83837),
  );
  static final TextStyle ReferralSlip = GoogleFonts.roboto(
    color: Color(0xFFC6221A),
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle visitorsdetails = GoogleFonts.roboto(
    color: Color(0xFF989898),
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle Category = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle apply = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle Reset = GoogleFonts.roboto(
    color: Color(0xFF1E8DD2), // Changed from 0xFF989898
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle addfilters = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle filtersgiven = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle filterdate = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle bottombartext = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle livelocation = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle Submit = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle Rivenrefsmall = GoogleFonts.roboto(
    color: Color(0xFF828282),
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle Refcontact = GoogleFonts.roboto(
    color: Color(0xFFC6221A),
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle reftext = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle refname = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 23.sp,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle networkerror = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle nxtmeet = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle membercard = GoogleFonts.roboto(
    color: Color(0xFF797373),
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle membername = GoogleFonts.roboto(
    color: Color(0xFFC6221A),
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle chapterrole = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle Attendancehead = GoogleFonts.roboto(
    color: Color(0xFFC6221A),
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle Scan = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 25.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle youratt = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 20.sp,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle attDone = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle membership = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle membershipstatus = GoogleFonts.roboto(
    color: Color(0xFF828282),
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
   static final TextStyle ProfileName = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle gripname = GoogleFonts.roboto(
    color: Color(0xFFC6221A),
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
}

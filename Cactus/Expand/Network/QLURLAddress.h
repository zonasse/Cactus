//
//  QLURLAddress.h
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/14.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#ifndef QLURLAddress_h
#define QLURLAddress_h

//URL根路径
#define kBASE_URL @"http://119.29.63.216:8000/api/v1/"
//#define kBASE_URL @"http://127.0.0.1:8000/api/v1/"

#define kURLFrame(str) [NSString stringWithFormat:@"%@%@",kBASE_URL,str]

#define kURL_lesson_format kURLFrame(@"table/lesson/format")

#define kURL_class_wrapper kURLFrame(@"table/class_field/wrapper")
#define kURL_class_format kURLFrame(@"table/class_field/format")

#define kURL_classInfo_format kURLFrame(@"table/class_info/format")
#define kURL_classInfo_display kURLFrame(@"table/class_info/display")

#define kURL_user_format kURLFrame(@"user/info/format")
#define kURL_user_display kURLFrame(@"user/info/display")
#define kURL_user_logon kURLFrame(@"user/logon")
#define kURL_user_login kURLFrame(@"user/login")
#define kURL_user_logout kURLFrame(@"user/logout")
#define kURL_user_manage kURLFrame(@"user/info/manage")

#define kURL_student_format kURLFrame(@"student/format")
#define kURL_student_display kURLFrame(@"student/display")

#define kURL_university_format kURLFrame(@"university/format")

#define kURL_college_display kURLFrame(@"college/display")
#define kURL_college_format kURLFrame(@"college/format")

#define kURL_major_format kURLFrame(@"major/format")

#define kURL_point_display kURLFrame(@"point/display")
#define kURL_point_format kURLFrame(@"point/format")

#define kURL_title_format kURLFrame(@"title/format")
#define kURL_title_display kURLFrame(@"title/display")

#define kURL_titleGroup_format kURLFrame(@"titleGroup/format")

#endif /* QLURLAddress_h */

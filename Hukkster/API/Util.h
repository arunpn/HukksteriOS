//
//  Util.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)searchString:(NSString *)searchingString inString:(NSString *)searchString withFullTextSearch:(BOOL)searchMode;
+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message andCancelButtonTitle:(NSString *)buttonTitle;
+ (BOOL)isIphone;
+ (BOOL)isRetinaDisplay;
+ (BOOL)string:(NSString *)string existsInArray:(NSMutableArray *)array;
+ (void)callPhoneNumber:(NSString *)number;
+ (void)openWebURL:(NSString *)url;
+ (id)setValueIfNotNSNull:(id)value;
+ (BOOL)isEmailValid:(NSString *)email;
+ (NSString *)addCSSToHTMLContent:(NSString *)htmlContent;
+ (NSString *)MD5HashForString:(NSString *)inputString;
+ (UIImageView *)modifyImageView:(UIImageView *)imageView withBorderColor:(UIColor *)color andWidth:(double)width;
+ (UIImageView *)modifyImageView:(UIImageView *)imageView withCornerRadius:(double)radius;
+ (void)fillView:(UIView *)view withGradientColors:(UIColor *)color1 andColor2:(UIColor *)color2;
+ (void)setNormalBackgroundImage:(UIImage *)normalImage andPhone5Image:(UIImage *)phone5Image forView:(UIView *)view;
+ (NSString *)capitalizeLetterWithIndex:(int)index ofString:(NSString *)string;
+ (NSString *)stripHTMLTags:(NSString *)string;
+ (void)sortArray:(NSMutableArray *)array withKey:(NSString *)key withAscending:(BOOL)ascending;
+ (NSString *)getStoryboardName;
+ (void)addShadowToView:(UIView *)view;
+ (CGRect)changeParamteter:(ParameterOption)parameter ofView:(UIView *)view toValue:(float)value;
+ (int)screenWidth;
+ (int)screenHeight;
+ (BOOL)isLoggedIn;
+(void) setLoggedIn:(BOOL)value;

+ (NSTimeInterval)convertStringToNSTimeInterval:(NSString *)string;
+ (NSString *)convertNSTimeIntervalToString:(NSTimeInterval)interval;
+ (NSString *)convertDateToString:(NSDate *)date;
+ (NSDate *)convertStringToDate:(NSString *)string;
+ (NSString *)extractCalendarComponent:(CalendarComponent)component fromDate:(NSDate *)date;
+ (NSDate *)getDateWithDay:(int)day month:(int)month year:(int)year;
+ (NSString *)timeForDisplay:(NSString *)time;
+ (NSString *)monthNameForDate:(NSDate *)date;
+ (NSString *)customMonthNameForMonth:(NSString *)month;
+ (NSString *)monthAndYearForDate:(NSDate *)date;
+ (BOOL)date:(NSDate *)date equalWithDate:(NSDate *)comparingDate;
@end
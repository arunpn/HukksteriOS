//
//  Util.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "DMManager.h"

@implementation Util

+ (BOOL)isEmpty:(NSString *)string
{
	if ([string length] == 0) {
		return YES;
	} else if ([string isEqual:EMPTY_STRING]) {
		return YES;
	} else if ([string isEqual:@" "]) {
		return YES;
	} else if (string == nil) {
		return YES;
	}
	
	return NO;
}

+ (BOOL)searchString:(NSString *)searchingString inString:(NSString *)searchString withFullTextSearch:(BOOL)searchMode
{
	if (searchMode) {
		// Full-text search
		if ([[searchingString lowercaseString] isEqualToString:[searchString lowercaseString]]) {
			return YES;
		}
	} else {
		NSRange textRange;
		textRange = [[searchingString lowercaseString] rangeOfString:[searchString lowercaseString]];
		
		if (textRange.location != NSNotFound) {
			return YES;
		}
	}
	
	return NO;
}

+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message andCancelButtonTitle:(NSString *)buttonTitle
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:title
						  message:message 
						  delegate:nil 
						  cancelButtonTitle:buttonTitle 
						  otherButtonTitles:nil];
	[alert show];
}

+ (BOOL)isIphone
{    
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isRetinaDisplay
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if ([screen respondsToSelector:@selector(scale)])
        scale = screen.scale;
    
	if (scale == 2.0f) 
        return YES;
	else 
        return NO;
}

+ (BOOL)string:(NSString *)string existsInArray:(NSMutableArray *)array
{
    if (array.count == 0 || array == nil) return NO;
    
    for (NSString *arrayString in array) {
        if ([string isEqualToString:arrayString]) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)callPhoneNumber:(NSString *)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]];
}

+ (void)openWebURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (id)setValueIfNotNSNull:(id)value
{
    return (value != [NSNull null]) ? value : nil;
}

+ (BOOL)isEmailValid:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    
    return isValid;
}

+ (NSString *)addCSSToHTMLContent:(NSString *)htmlContent
{
    // CSS
    NSString *css = [NSString stringWithFormat:@"<html> \n"
                     "<head> \n"
                     "<style type=\"text/css\"> \n"
                     "body { background-color: transparent; margin: 5px; padding: 5px; text-align: justify; font-family: \"%@\"; font-size: %@; color: #504A4A;}\n"
                     "</style> \n"
                     "</head> \n"
                     "<body>%@</body> \n"
                     "</html>", @"Helvetica", [NSNumber numberWithInt:12.0f], htmlContent];
    
    return css;
}

+ (NSString *)MD5HashForString:(NSString *)inputString
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    // Convert NSString into C-string and generate MD5 Hash
    CC_MD5([inputString UTF8String], [inputString length], result);
    
    // Convert C-string (the hash) into NSString
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

+ (UIImageView *)modifyImageView:(UIImageView *)imageView withBorderColor:(UIColor *)color andWidth:(double)width;
{
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.borderWidth = width;
    
    return imageView;
}

+ (UIImageView *)modifyImageView:(UIImageView *)imageView withCornerRadius:(double)radius
{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = radius;
    
    return imageView;
}

+ (void)fillView:(UIView *)view withGradientColors:(UIColor *)color1 andColor2:(UIColor *)color2
{
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = colors;
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)setNormalBackgroundImage:(UIImage *)normalImage andPhone5Image:(UIImage *)phone5Image forView:(UIView *)view
{
    if (IS_IPHONE_5) {
        view.backgroundColor = [UIColor colorWithPatternImage:phone5Image];
    } else {
        view.backgroundColor = [UIColor colorWithPatternImage:normalImage];
    }
}

+ (NSString *)capitalizeLetterWithIndex:(int)index ofString:(NSString *)string
{
    NSString *capitalizedString = [[[string substringToIndex:1] uppercaseString] stringByAppendingString:[string substringFromIndex:1]];
    
    return capitalizedString;
}

+ (NSString *)stripHTMLTags:(NSString *)string
{
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:EMPTY_STRING];
    
    return string;
}

+ (void)sortArray:(NSMutableArray *)array withKey:(NSString *)key withAscending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

+ (NSString *)getStoryboardName
{
    return @"iPhoneStoryboard";
}

+ (void)addShadowToView:(UIView *)view
{
    view.layer.cornerRadius = kDefaultCornerRadius;
    view.layer.shadowOpacity = 0.55f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 3.0f;
    view.layer.shadowOffset = CGSizeMake(1, 0);
}

+ (CGRect)changeParamteter:(ParameterOption)parameter ofView:(UIView *)view toValue:(float)value
{
    float x = (parameter == PARAMETER_X) ? value : view.frame.origin.x;
    float y = (parameter == PARAMETER_Y) ? value : view.frame.origin.y;
    float width = (parameter == PARAMETER_WIDTH) ? value : view.frame.size.width;
    float height = (parameter == PARAMETER_HEIGHT) ? value : view.frame.size.height;
    
    return CGRectMake(x, y, width, height);
}

+ (int)screenWidth
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if ([Util isIphone]) {
            if (IS_IPHONE_5) {
                return 568;
            } else {
                return 480;
            }
        } else {
            return 1024;
        }
    } else {
        if ([Util isIphone]) {
            return 320;
        } else {
            return 768;
        }
    }
}

+ (int)screenHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if ([Util isIphone]) {
            return 300;
        } else {
            return 748;
        }
    } else {
        if ([Util isIphone]) {
            if (IS_IPHONE_5) {
                return 548;
            } else {
                return 460;
            }
        } else {
            return 1004;
        }
    }
}

+ (BOOL)isLoggedIn
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:LOGGED_IN] isEqualToString:OK_STRING];
}

+(void) setLoggedIn:(BOOL)value{
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:OK_STRING forKey:LOGGED_IN];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:EMPTY_STRING forKey:LOGGED_IN];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Date methods

+ (NSTimeInterval)convertStringToNSTimeInterval:(NSString *)string
{
    // 00:03:05
    NSString *hours = [string substringToIndex:2];
    NSString *minutes = [[string substringFromIndex:3] substringToIndex:2];
    NSString *seconds = [[string substringFromIndex:6] substringToIndex:2];
    
    NSTimeInterval summary = [hours intValue] * 60 * 60 + [minutes intValue] * 60 + [seconds intValue];
    
    return summary;
}

+ (NSString *)convertNSTimeIntervalToString:(NSTimeInterval)interval
{
    int hours = floor(interval / 3600);
    int minutes = floor(((int)interval / 60) % 60);
    int seconds = (int)interval % 60;
    
    // 00:03:05
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSString *)convertDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm"];
    
    dateString = [NSString stringWithFormat:@"%@, %@, %@",[Util extractCalendarComponent:WEEKDAY_COMPONENT fromDate:date] , dateString, [Util timeForDisplay:[timeFormatter stringFromDate:date]]];
    
    return dateString;
}

+ (NSDate *)convertStringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // This is important - we set our input date format to match our input string
    // if format doesn't match we'll get nil from your string
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"]; // 2013-03-19 16:30:31
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    
    return dateFromString;
}

+ (NSString *)extractCalendarComponent:(CalendarComponent)component fromDate:(NSDate *)date
{
    /*
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
     NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
     
     switch (component) {
     case DAY_COMPONENT: return [components day]; break;
     case MONTH_COMPONENT: return [components month]; break;
     case YEAR_COMPONENT: return [components year]; break;
     }*/
    
    if (date == nil) return EMPTY_STRING;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (component) {
        case DAY_COMPONENT: [dateFormatter setDateFormat:@"dd"]; break;
        case MONTH_COMPONENT: [dateFormatter setDateFormat:@"MM"]; break;
        case YEAR_COMPONENT: [dateFormatter setDateFormat:@"yyyy"]; break;
        case WEEKDAY_COMPONENT: [dateFormatter setDateFormat:@"EEEE"]; break;
    }
    
    NSString *calendarComponent = [dateFormatter stringFromDate:date];
    
    return calendarComponent;
}

+ (NSDate *)getDateWithDay:(int)day month:(int)month year:(int)year
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:day];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:month];
    [dateFormatter setDateFormat:@"yyyy"];
    [dateComponents setYear:year];
    
    NSDate *result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

+ (NSString *)timeForDisplay:(NSString *)time
{
	NSArray *listItems = [time componentsSeparatedByString:@":"];
	
	NSString *hours = [listItems objectAtIndex:0];
	
	int h = [hours intValue];
	NSString *postfix = @"AM";
	
	if (h > 12 && h <=23) {
		h = h - 12;
		postfix = @"PM";
	}
	
	//NSString *result = [NSString stringWithFormat:@"%d:%@ %@", h, [listItems objectAtIndex:1], postfix];
    NSString *result = [NSString stringWithFormat:@"%@ %@", time, postfix];
	
	return result;
}

+ (NSString *)monthNameForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *result = [formatter stringFromDate:date];
    
    return result;
}

+ (NSString *)customMonthNameForMonth:(NSString *)month
{
    if ([month isEqualToString:@"1"] || [month isEqualToString:@"01"]) {
        return @"jan";
    } else if ([month isEqualToString:@"2"] || [month isEqualToString:@"02"]) {
        return @"feb";
    } else if ([month isEqualToString:@"3"] || [month isEqualToString:@"03"]) {
        return @"mar";
    } else if ([month isEqualToString:@"4"] || [month isEqualToString:@"04"]) {
        return @"apr";
    } else if ([month isEqualToString:@"5"] || [month isEqualToString:@"05"]) {
        return @"maj";
    } else if ([month isEqualToString:@"6"] || [month isEqualToString:@"06"]) {
        return @"jun";
    } else if ([month isEqualToString:@"7"] || [month isEqualToString:@"07"]) {
        return @"jul";
    } else if ([month isEqualToString:@"8"] || [month isEqualToString:@"08"]) {
        return @"avg";
    } else if ([month isEqualToString:@"9"] || [month isEqualToString:@"09"]) {
        return @"sep";
    } else if ([month isEqualToString:@"10"]) {
        return @"okt";
    } else if ([month isEqualToString:@"11"]) {
        return @"nov";
    } else if ([month isEqualToString:@"12"]) {
        return @"dec";
    }
    
    return EMPTY_STRING;
}

+ (NSString *)monthAndYearForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, yyyy"];
    NSString *result = [formatter stringFromDate:date];
    
    return result;
}

+ (BOOL)date:(NSDate *)date equalWithDate:(NSDate *)comparingDate
{
    int dateDay = [[self extractCalendarComponent:DAY_COMPONENT fromDate:date] intValue];
    int dateMonth = [[self extractCalendarComponent:MONTH_COMPONENT fromDate:date] intValue];
    int dateYear = [[self extractCalendarComponent:YEAR_COMPONENT fromDate:date] intValue];
    
    int comparingDateDay = [[self extractCalendarComponent:DAY_COMPONENT fromDate:comparingDate] intValue];
    int comparingDateMonth = [[self extractCalendarComponent:MONTH_COMPONENT fromDate:comparingDate] intValue];
    int comparingDateYear = [[self extractCalendarComponent:YEAR_COMPONENT fromDate:comparingDate] intValue];
    
    if (dateDay == comparingDateDay && dateMonth == comparingDateMonth && dateYear == comparingDateYear) {
        return YES;
    }
    
    return NO;
}

@end
//
//  Constants.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

// Application
#define kDebugging 1

// Notifications
static NSString *const NO_INTERNET_NOTIFICATION = @"NO_INTERNET_NOTIFICATION";
static NSString *const SHOW_MENU_NOTIFICATION   = @"SHOW_MENU_NOTIFICATION";

// URLs
static NSString *const URL                      = @"";
static NSString *const OFFICIAL_EMAIL           = @"";
static NSString *const OFFICIAL_PHONE           = @"";
static NSString *const YOUTUBE_THUMBNAIL        = @"http://img.youtube.com/vi/";

static NSString *const FACEBOOK_URL = @"https://www.facebook.com/Hukkster";
static NSString *const TWITTER_URL  = @"https://twitter.com/Hukkster";
static NSString *const YOUTUBE_URL  = @"http://www.youtube.com/channel/UCyNjXF8aBQXWeOJ8JnzaE3A";
static NSString *const ITUNES_URL   = @"";

// Strings
static NSString *const APP_NAME_STRING                  	= @"Hukkster";
static NSString *const EMPTY_STRING                         = @"";
static NSString *const NEW_LINE_CONSTANT_STRING             = @"\n";
static NSString *const OK_STRING                            = @"OK";
static NSString *const LOADING_STRING                       = @"Loading...";
// End: Strings

// Enums
typedef enum {
    DAY_COMPONENT = 1,
    MONTH_COMPONENT,
    YEAR_COMPONENT,
    WEEKDAY_COMPONENT
} CalendarComponent;

typedef enum {
    PARAMETER_X,
    PARAMETER_Y,
    PARAMETER_WIDTH,
    PARAMETER_HEIGHT
} ParameterOption;

typedef enum {
    PROCESS,
} WebServiceProcess;

typedef enum {
    LOGIN_PROCESS
} PostToWebServiceProcess;

typedef enum {
    FACEBOOK_SOCIAL_NETWORK = 1,
    TWITTER_SOCIAL_NETWORK,
    YOUTUBE_SOCIAL_NETWORK
} WebViewFlag;

typedef enum {
    FULLSIZE_IMAGE = 1,
    THUMB_IMAGE
} ImageOptions;

// NSUserDefaults
static NSString *const LOGGED_IN    = @"LOGGED_IN";
static NSString *const DEVICE_ID    = @"DEVICE_ID";
static NSString *const DEVICE_TOKEN = @"DEVICE_TOKEN";

// Segue
static NSString *const REGISTRATION_SEGUE       = @"Registration Segue";
static NSString *const UPDATE_PASSWORD_SEGUE    = @"Update Password Segue";
static NSString *const SIGN_UP_SEGUE            = @"Sign Up Segue";
static NSString *const TASTEMAKER_SEGUE         = @"Tastemaker Segue";
static NSString *const PIN_SEGUE                = @"Pin Segue";
static NSString *const TUTORIALS_SEGUE          = @"Tutorials Segue";

// Fonts
static NSString *const PROXIMA_NOVA_REGULAR_FONT    = @"ProximaNova-Regular";
static NSString *const PROXIMA_NOVA_BOLD_FONT       = @"ProximaNova-Bold";
static NSString *const PROXIMA_NOVA_LIGHT_FONT      = @"ProximaNova-Light";
static NSString *const PROXIMA_NOVA_THIN_FONT       = @"ProximaNova-Thin";
static NSString *const URWBODONI_LIGHT_FONT         = @"URWBodoniTOTLig";
static NSString *const URWBODONI_REGULAR_FONT       = @"URWBodoniTOT-Reg";
static NSString *const BODONI_BE_LIGHT_ITALIC_FONT  = @"BodoniBE-LightItalic";
static NSString *const BODONI_REGULAR_FONT          = @"Bodoni BE Regular";
static NSString *const HELVETICA_THIN_FONT          = @"HelveticaNeueLTPro-Th";
static NSString *const HELVETICA_BOLD_FONT          = @"HelveticaNeueLTPro-Bd";
#define kHyperlinkButtonDefaultSize 11.0
#define kButtonDefaultFontSize      16.0

// Colors
#define kLightGrayColor         [UIColor colorWithRed:80.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]
#define kDarkGrayColor          [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0]
#define kRedColor               [UIColor colorWithRed:231.0/255.0 green:95.0/255.0 blue:96.0/255.0 alpha:1.0]
#define kDefaultAlphaValue      0.8

// UITableView
#define kDefaultCornerRadius    3.0
#define kDefaultCellHeight      44.0
#define kDefaultSeparatorAlpha  0.2

// Macros
#define IMAGE(name)     [UIImage imageNamed:name]
#define IS_IPHONE_5     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define COLOR(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define VC(name)        [[UIStoryboard storyboardWithName:[Util getStoryboardName] bundle:nil] instantiateViewControllerWithIdentifier:name]

#define currencyToString(decimalValue) [NSString stringWithFormat:@"$%.0f",[[NSDecimalNumber decimalNumberWithDecimal:decimalValue] doubleValue]]

#define imageFromUrl(url) [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]

// Animations
#define kAnimationDuration 0.2

// UI Elements
#define kHeaderImageViewHeight 48.0
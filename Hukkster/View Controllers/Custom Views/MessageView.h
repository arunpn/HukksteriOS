//
//  MessageView.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EMAIL_SENT_MESSAGE_VIEW_TYPE,
    INVALID_MAIL_VIEW_TYPE,
    EXISTING_ACCOUNT_VIEW_TYPE,
    EXISTING_FACEBOOK_ACCOUNT_VIEW_TYPE,
    EXISTING_GOOGLE_ACCOUNT_VIEW_TYPE,
    CONFIRM_MAIL_VIEW_TYPE,
    OOPS_VIEW_TYPE,
    SOLD_OUT_VIEW_TYPE,
    NO_NETWORK_VIEW_TYPE,
    NOT_SUPPORTED_VIEW_TYPE,
    TECH_DIFFICULTIES_VIEW_TYPE,
    MANY_OPTIONS_VIEW_TYPE,
    SAVED_TO_YOUR_HUKKS_VIEW_TYPE,
    DELETE_LIST_VIEW_TYPE,
    HUKK_LIST_VIEW_TYPE,
    HUKK_PRODUCT_VIEW_TYPE,
    ARE_YOU_SURE_TYPE,
    EARN_SALES_KARMA_VIEW_TYPE,
    PURCHASING_ERROR_VIEW_TYPE,
    DID_WE_GET_IT_VIEW_TYPE,
    INVALID_BIRTHDAY_VIEW_TYPE
} MessageViewType;

@class MessageView;

@protocol MessageViewDelegate <NSObject>
@optional
- (void)messageViewClosed:(MessageView *)view;
@end

@interface MessageView : UIView
@property (copy, nonatomic) NSString *titleString;
@property (copy, nonatomic) NSString *detailString;
@property (copy, nonatomic) NSString *buttonString;
@property (copy, nonatomic) NSString *leftButtonString;
@property (copy, nonatomic) NSString *rightButtonString;
@property (nonatomic) MessageViewType viewType;
@property (assign, nonatomic) id <MessageViewDelegate> delegate;

- (void)configureUI;
- (IBAction)buttonTapped:(UIButton *)sender;
- (IBAction)leftButtonTapped:(UIButton *)sender;
- (IBAction)rightButtonTapped:(UIButton *)sender;
- (IBAction)closeButtonTapped:(UIButton *)sender;
@end
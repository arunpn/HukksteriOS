//
//  BaseViewController.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageView.h"
#import "DataController.h"
#import "HukkDataController.h"

typedef enum {
    POP_TYPE = 1,
    MODAL_TYPE
} ViewType;

@interface BaseViewController : UIViewController<DataControllerDelegate, HukkDataControllerDelegate>
@property (nonatomic) ViewType viewType;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *navigationBarImageView;
@property (nonatomic) BOOL swipeEnabled;
@property (readonly) DataController *dataController;
@property (readonly) HukkDataController *hukkDataController;

- (void)configureView;
- (void)showMessageViewForType:(MessageViewType)viewType;
- (void)share:(NSArray *)content;
- (IBAction)backButtonTapped:(UIButton *)sender;
- (IBAction)menuButtonTapped:(UIButton *)sender;
@end
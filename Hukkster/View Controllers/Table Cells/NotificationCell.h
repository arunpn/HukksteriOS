//
//  NotificationCell.h
//  Hukkster-jovan
//
//  Created by Jovan Tomasevic on 8/22/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificationTypeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@end
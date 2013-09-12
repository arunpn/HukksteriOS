//
//  MenuViewController.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

@protocol MenuDelegate <NSObject>
- (void)menuButtonTappedWithTag:(int)tag;
@end

@interface MenuViewController : BaseViewController
- (IBAction)menuItemButtonTapped:(UIButton *)sender;
@property (weak, nonatomic) id <MenuDelegate> delegate;
- (void)selectMenuItemWithButtonTag:(int)tag;
@end
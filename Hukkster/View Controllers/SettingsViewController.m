//
//  SettingsViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "SettingsViewController.h"
#import "NotificationCell.h"
#import "BaseCell.h"
#import "DateTimePicker.h"
#import "MainViewController.h"
#import "MenuViewController.h"

@interface SettingsViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, DateTimePickerDelegat>
@property (weak, nonatomic) IBOutlet UILabel *personalInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UITableView *personalInfoTableView;
@property (strong, nonatomic) DateTimePicker *datePicker;

@property (nonatomic) BOOL firstTime;
@property (nonatomic) NSInteger personlInfoCellCount;
@property (strong, nonatomic) NSMutableArray *rowLoaded;

- (void)configurePersonalInfoCell:(BaseCell *)cell;
- (void)configureInviteFriendCell:(BaseCell *)cell;
- (void)configureNotificationCell:(NotificationCell *)cell;
- (void)configureAboutCell:(BaseCell *)cell;
- (void)configureLogoutButtonCell:(BaseCell *)cell;
- (void)configureSilverLineCell:(BaseCell *)cell;

- (BaseCell *)createInviteFriendCell:(UITableView *)tableView;
- (BaseCell *)createPersonalInfoCell:(UITableView *)tableView atIndex:(NSInteger)index;
- (BaseCell *)createAboutCell:(UITableView *)tableView atIndex:(NSInteger)index;
- (NotificationCell *)createNotificationCell:(UITableView *)tableView atIndex:(NSInteger)index;
- (BaseCell *)createLogoutCell:(UITableView *)tableView;
- (BaseCell *)createSilverLineCell:(UITableView *)tableView;

- (UIView *)addHeaderToPersonalInfoTableViewSection:(UITableView *) tableView;
- (UIView *)addHeaderToInviteFriendsTableViewSection:(UITableView *) tableView;
- (UIView *)addHeaderToNotificationViewSection:(UITableView *) tableView;
- (UIView *)addHeaderToAboutCellSection:(UITableView *) tableView;
- (UIView *)addFooterToAboutTableSection:(UITableView *)tableView;

- (IBAction)logout:(id)sender;
@end

@implementation SettingsViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    self.settingsLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:17];
    self.personalInfoLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
}

#pragma mark - Private API

- (void)addTopEdge:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    imageView.image = [IMAGE(@"top_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(7, 0, 1, 0)];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12, 43, 296, 1)];
    [cell.contentView addSubview:separator];
    separator.backgroundColor = kDarkGrayColor;
    separator.alpha = 0.2;
    separator.tag = 11;
    imageView.tag = 11;
}

- (void)addBottomEdge:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    imageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
    imageView.tag = 11;
}

- (void)addMiddleEdge:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    imageView.image = [IMAGE(@"middle_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12, 44, 296, 1)];
    separator.tag = 11;
    [cell.contentView addSubview:separator];
    separator.backgroundColor = kDarkGrayColor;
    separator.alpha = 0.2;
    imageView.tag = 11;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: return self.personlInfoCellCount;
        case 1: return 1;
        case 2: return 2;
        case 3: return 4;
        case 4: return 1;
        case 5: return 1;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch(indexPath.section) {
        case 0:
            cell = [self createPersonalInfoCell:tableView atIndex:indexPath.row];
            break;
        case 1:
            cell = [self createInviteFriendCell:tableView];
            break;
        case 2:
            cell = [self createNotificationCell:tableView atIndex:indexPath.row];
            break;
        case 3:
            cell = [self createAboutCell:tableView atIndex:indexPath.row];
            break;
        case 4:
            // If break line just return cell, no frames...
            cell = [self createSilverLineCell:tableView];
            return cell;
        case 5:
            cell = [self createLogoutCell:tableView];
            // If logout just return cell, no frames...
            return cell;
            
    }
    // In first section first row simulate header, so don's drow border, just return cell
    if (indexPath.section == 0 && indexPath.row == 0){
        return cell;
    }

    for (NSInteger i = cell.contentView.subviews.count-1; i>=0; i--)  {
        UIView *view = [cell.contentView.subviews objectAtIndex:i];
        if(view.tag == 11){
            [view removeFromSuperview];
        }
    }

    if ((indexPath.row == 0 && indexPath.section!=1) || (indexPath.section == 0 && indexPath.row == 1)) {
        [self addTopEdge:cell];
    }
    // foreach section, for last cell except second section (invite firends - it has only one row)
    else if ((indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1 && indexPath.section == 0)
             || (indexPath.row == [self tableView:tableView numberOfRowsInSection:2] - 1 && indexPath.section == 2)
             || (indexPath.row == [self tableView:tableView numberOfRowsInSection:3] - 1 && indexPath.section == 3)){
        // insert bottom edge
        [self addBottomEdge:cell];
    }
    // special for invite friends
    else if(indexPath.section == 1) {
        // frist add top image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
        [cell.contentView addSubview:imageView];
        [cell.contentView sendSubviewToBack:imageView];
        imageView.frame = CGRectMake(8, 0, 304, 30);
        imageView.image = [IMAGE(@"top_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(7, 0, 1, 0)];
        imageView.tag =11;
        // and then bottom
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 30, 304, 17)];
        [cell.contentView addSubview:bottomImageView];
        [cell.contentView sendSubviewToBack:bottomImageView];
        bottomImageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
        bottomImageView.tag = 11;
    }
    // for cells in middle (not first or last)
    else {
        [self addMiddleEdge:cell];
    }
    
    return  cell;
}

#pragma mark - Handling personal info  table view section

- (void)configurePersonalInfoCell:(BaseCell *)cell
{
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    cell.textField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:15.0];
}

- (BaseCell *)createPersonalInfoCell:(UITableView *)tableView atIndex:(NSInteger)index
{
    static NSString *personalInfoCellIdentifier = @"PersonalInfoCell";
    BaseCell *personalInfoCell = [tableView dequeueReusableCellWithIdentifier:personalInfoCellIdentifier];
    personalInfoCell.textField.tag = index;
    
    switch (index) {
        case 0:
            personalInfoCell = [self simulateHeader:tableView];
            break;
        case 1:
            personalInfoCell.headingLabel.text = @"First Name";
            personalInfoCell.textField.text = @"Stephen";
            break;
        case 2:
            personalInfoCell.headingLabel.text = @"Last Name";
            personalInfoCell.textField.text = @"Lynch";
            break;
        case 3:
            personalInfoCell.headingLabel.text = @"Birthday";
            personalInfoCell.textField.text = @"1/14/84";
            break;
        case 4:
            personalInfoCell.headingLabel.text = @"Gender";
            personalInfoCell.textField.text = @"Male";
            break;
        case 5:
            personalInfoCell.headingLabel.text = @"Email";
            personalInfoCell.textField.text = @"smlynch@me.com";
            break;
        case 6:
            personalInfoCell.headingLabel.text = @"Password";
            personalInfoCell.textField.placeholder = @"Create password";
            break;
        case 7:
            personalInfoCell.headingLabel.text = @"Confirm Password";
            personalInfoCell.textField.placeholder = @"";
            break;
        default:
            break;
    }
    
    personalInfoCell.textField.delegate = self;
    [self configurePersonalInfoCell:personalInfoCell];
    
    return personalInfoCell;
}

// TODO: delete method
- (UIView *)addHeaderToPersonalInfoTableViewSection:(UITableView *)tableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 285, 24)];
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.frame];
    label.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
    label.text = @"Personal Information";
    headerView.backgroundColor = [UIColor clearColor];
    label.backgroundColor =[UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (BaseCell *)simulateHeader:(UITableView *)tableView
{
    static NSString *personalInfoCellIdentifier = @"PersonalInfoCell";
    BaseCell *personalInfoCell = [tableView dequeueReusableCellWithIdentifier:personalInfoCellIdentifier];
    personalInfoCell.backgroundColor = [UIColor clearColor];
    personalInfoCell.headingLabel.hidden = YES;
    personalInfoCell.textField.hidden = YES;
    
    CGRect frame = CGRectMake(12, 3, 285, 30);
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
    label.text = @"Personal Information";
    label.backgroundColor = [UIColor clearColor];
    
    [personalInfoCell addSubview:label];
    
    return personalInfoCell;
}

#pragma mark - Invite friend table view section

- (void)configureInviteFriendCell:(BaseCell *)cell
{
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
}

- (BaseCell *)createInviteFriendCell:(UITableView *)tableView
{
    static NSString *inviteFriendsCellIdentifier = @"InviteFriendsCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteFriendsCellIdentifier];
    [self configureInviteFriendCell:cell];
    
    return cell;
}

- (UIView *)addHeaderToInviteFriendsTableViewSection:(UITableView *)tableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0 )];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}

#pragma mark - Notification table view section

- (void)configureNotificationCell:(NotificationCell *)cell
{
    cell.notificationTypeLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    //cell.subheadingLabel.adjustsFontSizeToFitWidth = YES;
}

- (NotificationCell *)createNotificationCell:(UITableView *)tableView atIndex:(NSInteger)index
{
    static NSString *notificationCellIdentifier = @"NotificationCell";
    NotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    switch (index) {
        case 0:
            notificationCell.notificationTypeLabel.text = @"Email";
            notificationCell.switcher.selected = YES;
            break;
        case 1:
            notificationCell.notificationTypeLabel.text = @"Push Notification";
            notificationCell.switcher.selected = NO;
            break;
    }
    
    [self configureNotificationCell:notificationCell];
    
    return notificationCell;
}

- (UIView *)addHeaderToNotificationViewSection:(UITableView *)tableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12, 3, 285, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.frame];
    label.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
    label.text = @"Notification";
    headerView.backgroundColor = [UIColor clearColor];
    label.backgroundColor =[UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - About hukkster table view section

- (void)configureAboutCell:(BaseCell *)cell
{
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    //cell.subheadingLabel.adjustsFontSizeToFitWidth = YES;
}

- (BaseCell *)createAboutCell:(UITableView *)tableView atIndex:(NSInteger)index
{
    static NSString *aboutCellIdentifier = @"AboutCell";
    BaseCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier];
    switch (index) {
        case 0:
            aboutCell.headingLabel.text = @"View Tutorials";
            break;
        case 1:
            aboutCell.headingLabel.text = @"FAQ";
            break;
        case 2:
            aboutCell.headingLabel.text = @"Customer Support";
            break;
        case 3:
            aboutCell.headingLabel.text = @"About Us";
            break;
    }
    
    [self configureAboutCell:aboutCell];
    
    return aboutCell;
}

- (UIView *)addHeaderToAboutCellSection:(UITableView *)tableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12, 3, 285, 27)];
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.frame];
    label.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
    label.text = @"About Hukkster";
    headerView.backgroundColor = [UIColor clearColor];
    label.backgroundColor =[UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

// TODO: delete method
- (UIView *)addFooterToAboutTableSection:(UITableView *)tableView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(12, 3, 285, 10)];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 1)];
    [footerView addSubview:separator];
    separator.backgroundColor = kDarkGrayColor;
    separator.alpha = 0.2;
    
    return footerView;
}



#pragma mark - Log Out table view cell

- (void)configureLogoutButtonCell:(BaseCell *)cell
{
    cell.button.layer.cornerRadius = kDefaultCornerRadius;
    cell.button.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    [cell.button setBackgroundImage:IMAGE(@"ting") forState:UIControlStateHighlighted];
}

- (BaseCell *)createLogoutCell:(UITableView *)tableView
{
    static NSString *logoutCelldentifier = @"LogoutCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutCelldentifier];
    [self configureLogoutButtonCell:cell];
    
    return cell;
}

// log out action
- (IBAction)logout:(id)sender {
    [self.dataController logOut];
}
-(void)logoutResponse:(MetaData *)meta{
    [Util setLoggedIn:NO];
    [self performSegueWithIdentifier:@"gotoHomeScreen" sender:nil];
}

#pragma mark - Gray Line table view cell

- (void)configureSilverLineCell:(BaseCell *)cell
{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 8, self.view.frame.size.width, 1)];
    [cell addSubview:separator];
    separator.backgroundColor = kDarkGrayColor;
    separator.alpha = 0.2;
}

- (BaseCell *)createSilverLineCell:(UITableView *)tableView
{
    static NSString *silverLineCellIdentifier = @"SilverLineCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:silverLineCellIdentifier];
    [self configureSilverLineCell:cell];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7 && indexPath.section == 0) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 26;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 5;
        case 2:
            return 28;
        case 3:
            return 27;
        case 4:
        case 5:
            return 0;
        default:
            return 20;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 4:return 20;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"openViewTutorials" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"openFAQScreen" sender:nil];
                break;
            case 2:
                [self performSegueWithIdentifier:@"openCustomerSupport" sender:nil];
                break;
            case 3:
                [self performSegueWithIdentifier:@"openAboutHukksterScreen" sender:nil];
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        // case 0: return [self addHeaderToPersonalInfoTableViewSection:tableView];
        case 1: return [self addHeaderToInviteFriendsTableViewSection:tableView];
        case 2: return [self addHeaderToNotificationViewSection:tableView];
        case 3: return [self addHeaderToAboutCellSection:tableView];
        default:return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

// TODO: Remove method
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
            //case 3:
            //    return [self addFooterToAboutTableSection:tableView];
            //    break;
            
        default:
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0 )];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField.tag == 4){ // Gender
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose your gender:"
                                                                delegate	:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Female",@"Male", nil];
        [actionSheet showInView:self.view];
    } else if (textField.tag == 3){ // Birth date
        self.datePicker = [[[NSBundle mainBundle] loadNibNamed:@"DateTimePicker" owner:self options:nil] objectAtIndex:0];
        
        self.datePicker = [[DateTimePicker alloc]init];
        self.datePicker.alpha = 0.0;
        self.datePicker.delegate = self;
        [self.view addSubview:self.datePicker];
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.datePicker.alpha = 1.0;
        }];
    } else if (textField.tag == 6) { // Password
        // Move to position on screen where can also confirm password is visible
        self.personalInfoTableView.contentInset =  UIEdgeInsetsMake(0, 0, 50, 0);
        [self.personalInfoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:	UITableViewScrollPositionTop animated:YES];
        if (self.personlInfoCellCount == 8) {
            
        } else {
            // Change number of cells to include confirm password field
            self.personlInfoCellCount = 8;
            // Get password cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
            BaseCell *cell = (BaseCell *)[self.personalInfoTableView cellForRowAtIndexPath:indexPath];
            // Remove top edge image from password cell
            UIImageView *borderView = (UIImageView *) [cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-3];
            [borderView removeFromSuperview];
            // Add middle image to cell
            [self addMiddleEdge:cell];
            // Send message to table view to show confirm message field.
            // we call method insert, and controller call then tableView:cellForRowAtIndexPath 
            indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
            
            NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
            [self.personalInfoTableView beginUpdates];            
            [self.personalInfoTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            [self.personalInfoTableView endUpdates];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 6){ // Password
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        BaseCell *cellConfirmPass = (BaseCell *)[self.personalInfoTableView cellForRowAtIndexPath:indexPath];
        [cellConfirmPass.textField becomeFirstResponder];
    } else if (textField.tag == 7){ // Confirm password
        // Change number of cells to exclude confirm password field
        self.personlInfoCellCount = 7;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
        [self.personalInfoTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        
        // Get password field and remove edge images
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        BaseCell *cell = (BaseCell *)[self.personalInfoTableView cellForRowAtIndexPath:indexPath];
        UIImageView *borderView = (UIImageView *) [cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-4];
        [borderView removeFromSuperview];
        borderView = (UIImageView *) [cell.contentView.subviews objectAtIndex:cell.contentView.subviews.count-1];
        [borderView removeFromSuperview];
        // add bottom edge.
        [self addBottomEdge:cell];
        borderView.tag = 11;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BaseCell *cell = (BaseCell *)[self.personalInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (buttonIndex == 0){
        cell.textField.text = @"Female";
    } else{
        cell.textField.text = @"Male";
    }
    
    [cell.textField resignFirstResponder];
}

#pragma mark - DateTimePickerDelegate

- (void)confirmDate:(NSDate *)date
{
    // TODO
}

- (void)closePicker
{
    // TODO
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.viewType = POP_TYPE;
    self.firstTime = YES;
    self.personlInfoCellCount = 7;
    self.rowLoaded = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //if (![Util isLoggedIn]){
        MainViewController *vc = (MainViewController *)self.parentViewController.parentViewController;
        [vc.menuVC selectMenuItemWithButtonTag:0]; // Top Hukks
    //}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.firstTime = YES;
    self.personlInfoCellCount = 7;
}

@end
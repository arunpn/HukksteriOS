//
//  TagsView.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 7.9.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagsView;

@protocol TagsViewDelegate <NSObject>
@optional
- (void)tagsViewButtonTapped:(TagsView *)tagsView;
@end

typedef enum {
    FADE_EFFECT,
    BUBBLE_EFFECT,
    ENTER_EFFECT,
    RISE_EFFECT,
    RIPPLE_EFFECT,
    PUSH_EFFECT,
    REVEAL_EFFECT,
    SUCK_EFFECT,
    CURL_EFFECT,
    CUBE_EFFECT
} TagsViewEffect;

@interface TagsView : UIView
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *tagsArray;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *highlightedColor;
@property (strong, nonatomic) UIColor *normalTextColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) UIFont *buttonFont;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<TagsViewDelegate> delegate;
@property (nonatomic) BOOL singleSelection;
@property (nonatomic) TagsViewEffect effect;

- (void)animate;
- (void)configureView;
- (NSString *)getSelectedValues;
- (void)selectButton:(NSString *)buttonTitle;
@end
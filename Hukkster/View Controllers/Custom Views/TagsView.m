//
//  TagsView.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 7.9.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "TagsView.h"
#import <QuartzCore/QuartzCore.h>

#define kSeparatorWidth 5
#define kCornerRadius   9
#define kTagSize        25

@interface TagsView()
@property (strong, nonatomic) NSMutableArray *buttonsArray;

- (void)buttonTapped:(UIButton *)sender;
- (void)fadeEffect;
- (void)bubbleEffect;
- (void)enterEffect;
- (void)riseEffect;
- (void)rippleEffect;
- (void)pushEffect;
- (void)revealEffect;
- (void)suckEffect;
- (void)curlEffect;
- (void)cubeEffect;
@end

@implementation TagsView

#pragma mark - Properties

- (NSMutableArray *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    
    return _buttonsArray;
}

#pragma mark - Designated Initializer

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.effect = FADE_EFFECT;
    }
    
    return self;
}


#pragma mark - Public API

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *button = nil;
    int nextX = 0;
    int nextY = 0;
    for (int i = 0; i < self.tagsArray.count; i++) {
        NSString *tag = [self.tagsArray objectAtIndex:i];
        CGSize tagSize = [tag sizeWithFont:self.buttonFont];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.normalColor];
        [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
        [button setTitle:tag forState:UIControlStateNormal];
        button.titleLabel.font = self.buttonFont;
        button.layer.cornerRadius = kCornerRadius;
        
        if (nextX >= self.frame.size.width - 10) {
            nextX = 0;
            nextY = nextY + kTagSize + 3;
        }
        
        if (nextY >= self.frame.size.height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + nextY);
            [self setNeedsDisplay];
        }
        
        button.frame = CGRectMake(nextX, nextY, tagSize.width + 10, kTagSize);
        button.tag = i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonsArray addObject:button];
        
        nextX = button.frame.size.width + button.frame.origin.x + kSeparatorWidth;
    }
}

- (NSString *)getSelectedValues
{
    NSString *values = @"";
    
    NSMutableArray *selectedButtonsArray = [NSMutableArray array];
    for (UIButton *button in self.buttonsArray) {
        if (button.selected) [selectedButtonsArray addObject:button];
    }
    
    for (int i = 0; i < selectedButtonsArray.count; i++) {
        UIButton *button = [selectedButtonsArray objectAtIndex:i];
        if (i == 0) {
            if (button.selected) {
                values = [values stringByAppendingString:[NSString stringWithFormat:@"%@", [button titleForState:UIControlStateNormal]]];
            }
        } else {
            if (button.selected) {
                values = [values stringByAppendingString:[NSString stringWithFormat:@", %@", [button titleForState:UIControlStateNormal]]];
            }
        }
    }
    
    //NSLog(@"%@", values);
    
    return values;
}

- (void)animate
{
    if (self.effect == FADE_EFFECT) {
        [self fadeEffect];
    } else if (self.effect == BUBBLE_EFFECT) {
        [self bubbleEffect];
    } else if (self.effect == ENTER_EFFECT) {
        [self enterEffect];
    } else if (self.effect == RISE_EFFECT) {
        [self riseEffect];
    } else if (self.effect == RIPPLE_EFFECT) {
        [self rippleEffect];
    } else if (self.effect == PUSH_EFFECT) {
        [self pushEffect];
    } else if (self.effect == REVEAL_EFFECT) {
        [self revealEffect];
    } else if (self.effect == SUCK_EFFECT) {
        [self suckEffect];
    } else if (self.effect == CURL_EFFECT) {
        [self curlEffect];
    } else if (self.effect == CUBE_EFFECT) {
        [self cubeEffect];
    }
}

- (void)selectButton:(NSString *)buttonTitle
{
    for (UIButton *button in [self subviews]) {
        if ([[button titleForState:UIControlStateNormal] isEqualToString:buttonTitle]) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

#pragma mark - Actions

- (void)buttonTapped:(UIButton *)sender
{
    if (self.singleSelection) { // Exclude others
        for (UIButton *button in self.buttonsArray) {
            button.backgroundColor = self.normalColor;
            button.selected = NO;
        }
        
        sender.backgroundColor = self.highlightedColor;
        sender.selected = YES;
    } else {
        sender.backgroundColor = (sender.backgroundColor == self.normalColor) ? self.highlightedColor : self.normalColor;
        sender.selected = !sender.selected;
        
        [self getSelectedValues];
    }
    
    if (self.delegate) [self.delegate tagsViewButtonTapped:self];
}

#pragma mark - Private API

- (void)fadeEffect
{
    for (UIButton *button in self.buttonsArray) {
        button.alpha = 0.0;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        for (UIButton *button in self.buttonsArray) {
            button.alpha = 1.0;
        }
    }];
}

- (void)bubbleEffect
{
    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounceAnimation.duration = 0.2;
    bounceAnimation.fromValue = [NSNumber numberWithInt:0];
    bounceAnimation.toValue = [NSNumber numberWithInt:10];
    bounceAnimation.repeatCount = 2;
    bounceAnimation.autoreverses = YES;
    bounceAnimation.fillMode = kCAFillModeForwards;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.additive = YES;
    
    for (UIButton *button in self.buttonsArray) {
        int duration = (arc4random() % 6) + 1;
        bounceAnimation.duration = duration/10;
        
        int fromValue = (arc4random() % 25) + 10;
        bounceAnimation.fromValue = [NSNumber numberWithInt:-fromValue];
        
        int repeatCount = (arc4random() % 3) + 1;
        bounceAnimation.repeatCount = repeatCount;
        [button.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    }
}

- (void)enterEffect
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (UIButton *button in self.buttonsArray) {
        button.alpha = 0.0;
        [dictionary setObject:[NSNumber numberWithInt:button.frame.origin.y] forKey:[NSNumber numberWithInt:button.tag]];
        
        button.frame = CGRectMake(button.frame.origin.x,
                                  button.frame.origin.y - 100,
                                  button.frame.size.width,
                                  button.frame.size.height);
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        for (UIButton *button in self.buttonsArray) {
            button.alpha = 1.0;
            
            button.frame = CGRectMake(button.frame.origin.x,
                                      [[dictionary objectForKey:[NSNumber numberWithInt:button.tag]] intValue],
                                      button.frame.size.width,
                                      button.frame.size.height);
        }
    }];
}

- (void)riseEffect
{
    for (UIButton *button in self.buttonsArray) {
        button.frame = CGRectMake(button.frame.origin.x,
                                  button.frame.origin.y,
                                  button.frame.size.width,
                                  0);
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        for (UIButton *button in self.buttonsArray) {
            button.frame = CGRectMake(button.frame.origin.x,
                                      button.frame.origin.y,
                                      button.frame.size.width,
                                      kTagSize);
        }
    }];
}

- (void)rippleEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.type = @"rippleEffect";
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

- (void)pushEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

- (void)revealEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.type = kCATransitionReveal;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

- (void)suckEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.type = @"suckEffect";
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

- (void)curlEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.type = @"pageCurl";
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

- (void)cubeEffect
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    for (UIButton *button in self.buttonsArray) {
        [button.layer addAnimation:animation forKey:NULL];
    }
}

/*
 kCATransitionFade
 kCATransitionMoveIn
 kCATransitionPush
 kCATransitionReveal
 @"cameraIris"
 @"cameraIrisHollowOpen"
 @"cameraIrisHollowClose"
 @"cube"
 @"alignedCube"
 @"flip"
 @"alignedFlip"
 @"oglFlip"
 @"rotate"
 @"pageCurl"
 @"pageUnCurl"
 @"rippleEffect"
 @"suckEffect"
 
 Subtypes that are available are:
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 */

@end
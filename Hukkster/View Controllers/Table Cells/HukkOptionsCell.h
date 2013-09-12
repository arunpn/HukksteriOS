//
//  HukkOptionsCell.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 11.9.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "BaseCell.h"
#import "TagsView.h"

@interface HukkOptionsCell : BaseCell
@property (weak, nonatomic) IBOutlet TagsView *tagsView;
@end
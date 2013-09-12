//
//  HukkCell.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 20.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "BaseCell.h"

@interface HukkCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *enterCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *foundOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@end
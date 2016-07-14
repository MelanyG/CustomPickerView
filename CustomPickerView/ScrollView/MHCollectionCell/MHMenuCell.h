//
//  MHCollectionCell.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHConfigure.h"
#import "WTURLImageView.h"


@interface MHMenuCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet WTURLImageView *imageContainer;
@property (weak, nonatomic) IBOutlet UIView *splitter;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) IBOutlet UILabel *textLable;

- (void)setVisibleSplitter:(NSInteger)index;

@end

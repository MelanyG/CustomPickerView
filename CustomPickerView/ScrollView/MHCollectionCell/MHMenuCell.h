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
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfSplitterConstraint;
@property (strong, nonatomic) NSString *accessibilityText;

- (void)setVisibleSplitter:(NSInteger)index;

@end

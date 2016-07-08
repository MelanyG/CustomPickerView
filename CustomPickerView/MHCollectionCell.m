//
//  MHCollectionCell.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHCollectionCell.h"

@implementation MHCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.splitterWasSet = NO;
//        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:0.8f];
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.borderWidth = 3.0f;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowRadius = 3.0f;
//        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//        self.layer.shadowOpacity = 0.5f;
//        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        self.layer.shouldRasterize = YES;
//        self.imageContainer = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageContainer.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageContainer.clipsToBounds = YES;
        
        [self.contentView addSubview:self.imageContainer];
    }
    return self;
}


- (void)setSplitter
{
    if ((!self.splitterWasSet) && [MHConfigure sharedConfiguration].streamPickerDisplaySplitters) {
        CGSize mainViewSize = self.bounds.size;
        NSInteger borderWidth = [MHConfigure sharedConfiguration].streamPickerSplitterWidth;
        UIColor *borderColor = [MHConfigure sharedConfiguration].streamPickerSplitterColor;
      // self.splitter.frame =CGRectMake(0, 0, borderWidth, mainViewSize.height);
        self.splitter.hidden = NO;
        self.splitter.backgroundColor = [UIColor redColor];
        
        // for bonus points, set the views' autoresizing mask so they'll stay with the edges:
      //  self.splitter.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        
        //[self addSubview:self.splitter];
        self.splitterWasSet = YES;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageContainer.image = nil;
}


@end

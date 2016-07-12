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

}


- (void)setVisibleSplitter:(NSInteger)index
{
    if(index == 0) {
        self.splitter.hidden = YES;
        return;
    }
    if ([MHConfigure sharedConfiguration].streamPickerDisplaySplitters) {
        //        CGSize mainViewSize = self.bounds.size;
        //        NSInteger borderWidth = [MHConfigure sharedConfiguration].streamPickerSplitterWidth;
        //        UIColor *borderColor = [MHConfigure sharedConfiguration].streamPickerSplitterColor;
        self.splitter.hidden = NO;
        self.splitter.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerSplitterColor];
        
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageContainer.image = nil;
}


@end

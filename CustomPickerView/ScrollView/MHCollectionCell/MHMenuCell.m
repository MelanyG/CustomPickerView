//
//  MHCollectionCell.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHMenuCell.h"


@implementation MHMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setVisibleSplitter:(NSInteger)index {
    if(index == 0) {
        self.splitter.hidden = YES;
        return;
    }
    if ([MHConfigure sharedConfiguration].streamPickerDisplaySplitters) {
        self.splitter.hidden = NO;
        self.splitter.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerSplitterColor];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageContainer.image = nil;
}


@end

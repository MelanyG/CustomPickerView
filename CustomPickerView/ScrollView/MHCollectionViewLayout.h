//
//  MHCollectionViewLayout.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger maxElements;
@property (nonatomic) NSInteger numberOfElemets;
@property (nonatomic) CGFloat spacingX;

- (void)setup;

@end

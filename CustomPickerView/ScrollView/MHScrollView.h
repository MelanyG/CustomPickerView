//
//  ScrollView.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollectionViewLayout.h"
#import "MHCollectionCell.h"


@interface MHScrollView : UIView 


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;
@property (nonatomic, weak) IBOutlet MHCollectionViewLayout *customLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pagerWidthConstraint;

-(void)awakeFromNib;



@end


//
//  MHScrollVC.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollectionViewLayout.h"

@protocol MHMenuVCProtocol <NSObject>

- (void)didSelectCell:(NSInteger)selectedCell;
- (void)shouldUpdateHeighOfMenuContainer;

@end


@interface MHMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id <MHMenuVCProtocol> delegate;
@property (strong, nonatomic) NSArray *arrayOfModels;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;
@property (weak, nonatomic) IBOutlet MHCollectionViewLayout *customLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pagerHeightConstraint;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *activePageDotColor;
@property (nonatomic, retain) UIColor *inactivePageDotColor;

- (id)init;
- (void)updateAll;

@end

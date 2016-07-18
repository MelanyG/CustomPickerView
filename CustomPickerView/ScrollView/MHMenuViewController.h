//
//  MHScrollVC.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollectionViewLayout.h"


@protocol MHMenuViewControllerDelegate <NSObject>

- (void)didSelectCell:(NSInteger)selectedCell;
- (void)shouldUpdateHeighOfMenuContainer;

@end


@interface MHMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MHCollectionViewLayoutDelegate>

@property (weak, nonatomic) id <MHMenuViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *arrayOfModels;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;
@property (weak, nonatomic) IBOutlet MHCollectionViewLayout *customLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pagerHeightConstraint;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *activePageDotColor;
@property (nonatomic, retain) UIColor *inactivePageDotColor;
@property (assign, nonatomic) BOOL initialScrollDone;
@property (strong, nonatomic) NSIndexPath *activeIndex;

- (id)initWithArray:(NSArray *)array;
- (void)updateAll;
- (void)orientationChanged;
- (void)updateAllWithoutRotation;

@end

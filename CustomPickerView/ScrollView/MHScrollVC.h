//
//  MHScrollVC.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollectionViewLayout.h"

@protocol MHScrollVCProtocol <NSObject>

- (void)didSelectCell:(NSInteger)selectedCell;
- (void)shouldUpdatePageControl;

@end


@interface MHScrollVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id <MHScrollVCProtocol> delegate;
@property (strong, nonatomic) NSArray *swipeItems;
@property (strong, nonatomic) NSMutableDictionary *swipeModelItems;
@property (strong, nonatomic) NSString *associatedWith;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;
@property (weak, nonatomic) IBOutlet MHCollectionViewLayout *customLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pagerWidthConstraint;

- (id)init;

@end

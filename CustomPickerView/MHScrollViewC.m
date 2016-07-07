//
//  MHScrollViewC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHScrollViewC.h"
#import "Downloader.h"
#import "MHCollectionViewLayout.h"
#import "MHCollectionCell.h"
#import "MHConfigure.h"

@interface MHScrollViewC ()

@property(strong, nonatomic) Downloader *downloader;

@end

@implementation MHScrollViewC



-(id)initWithView:(UIView *) scroll {
    self = [super init];
    if (self != nil)
    {
    //    self.downloader = [Downloader new];
        self.scrollView = [[[NSBundle mainBundle] loadNibNamed:@"MHScrollView" owner:self options:nil] objectAtIndex:0];

    self.scrollView.frame = CGRectMake(scroll.bounds.origin.x, scroll.bounds.origin.y, scroll.bounds.size.width, scroll.bounds.size.height);
        //self.scrollView.collectionView.scrollEnabled = YES;
        //self.scrollView.backgroundColor = [UIColor redColor];
    
        [scroll addSubview:self.scrollView];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(orientationChanged:)
         name:UIDeviceOrientationDidChangeNotification
         object:[UIDevice currentDevice]];
         [self removePageControl];
         // self.scrollView = [[MHScrollView alloc]init];
       // [scroll addSubview:_scrollView];
    }
    return self;
}

- (void) orientationChanged:(NSNotification *)note
{
    [self.scrollView.collectionView reloadData];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TestCell";

    MHCollectionCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                              forIndexPath:indexPath];
    if(indexPath.row % 2) {
    cell.imageContainer.image = [UIImage imageNamed:@"penguin"];
    } else {
     cell.imageContainer.image = [UIImage imageNamed:@"bird1"];
    }
    if (indexPath.row != 0) {
        [cell setSplitter];
    }
    return cell;

}

- (void)removePageControl
{
    NSInteger height = 16;
//    UIPageControl *control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1.25 * height, self.bounds.size.width, height)];
//    self.pageControl = control;
    self.scrollView.pager.hidesForSinglePage = YES;
    self.scrollView.pager.pageIndicatorTintColor = [MHConfigure sharedConfiguration].inactivePageDotColor;
    self.scrollView.pager.currentPageIndicatorTintColor = [MHConfigure sharedConfiguration].activePageDotColor;
    self.scrollView.pager.defersCurrentPageDisplay = YES;
   // self.scrollView.pagerWidthConstraint.constant = 0;
   // [self.scrollView.pager removeFromSuperview];
   // self.scrollView.pager = nil;
    //[self insertSubview:control aboveSubview:_scrollView];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end

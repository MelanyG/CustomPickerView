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
@property (strong, nonatomic) NSMutableSet * set;
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
        _swipeItems = [[NSMutableDictionary alloc]init];
        _set = [[NSMutableSet alloc]init];
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
    return [[MHConfigure sharedConfiguration]numberOfElements];
}

- (MHCollectionCell *)collectionView:(UICollectionView *)collectionView
              cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TestCell";
    NSString *stringIndex = [NSString stringWithFormat:@"%li", indexPath.item];
    MHCollectionCell *oldCell = _swipeItems[stringIndex];
    MHCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(oldCell.imageContainer.image == nil) {
        //  MHCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];        if(indexPath.item % 2) {
        if(indexPath.item % 2) {
            cell.imageContainer.image = [UIImage imageNamed:@"penguin"];
        } else {
            cell.imageContainer.image = [UIImage imageNamed:@"bird1"];
        }
        if (indexPath.item != 0) {
            [cell setSplitter];
        }
        
        [_swipeItems setObject:cell forKey:stringIndex];
        [_set addObject:cell];
        //return cell;
        
    } else {
        cell = [_swipeItems objectForKey: stringIndex];
    }
    //UIImage *im = cell.imageContainer.image;
    //
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHCollectionCell *cell = (MHCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageContainer.image = [UIImage imageNamed:@"cat"];
    [_swipeItems removeObjectForKey:[NSString stringWithFormat:@"%li", indexPath.item]];
    [_swipeItems setObject:cell forKey:[NSString stringWithFormat:@"%li", indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHCollectionCell *cell = (MHCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.imageContainer.image = [UIImage imageNamed:@"cat"];
    [_swipeItems removeObjectForKey:[NSString stringWithFormat:@"%li", indexPath.item]];
    if(indexPath.item % 2) {
        cell.imageContainer.image = [UIImage imageNamed:@"penguin"];
    } else {
        cell.imageContainer.image = [UIImage imageNamed:@"bird1"];
    }
    
    [_swipeItems setObject:cell forKey:[NSString stringWithFormat:@"%li", indexPath.item]];
    
    NSLog(@"deselect clicked %@",[NSString stringWithFormat:@"%li", indexPath.item] );
}

- (void)updateDataSource: (NSIndexPath *)indexPath {
    MHCollectionCell *newCell = _swipeItems[[NSString stringWithFormat:@"%li", indexPath.item]];
    newCell.imageContainer.image = [UIImage imageNamed:@"cat"];
    
}

- (void)removePageControl
{
    //   NSInteger height = 16;
    //    UIPageControl *control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1.25 * height, self.bounds.size.width, height)];
    //    self.pageControl = control;
    if(self.scrollView.customLayout.maxElements >= self.scrollView.customLayout.numberOfElemets) {
        self.scrollView.pager.hidden = YES;
    } else {
        self.scrollView.pager.hidesForSinglePage = YES;
        self.scrollView.pager.pageIndicatorTintColor = [MHConfigure sharedConfiguration].inactivePageDotColor;
        self.scrollView.pager.currentPageIndicatorTintColor = [MHConfigure sharedConfiguration].activePageDotColor;
        self.scrollView.pager.defersCurrentPageDisplay = YES;
        CGFloat allPages = self.scrollView.customLayout.numberOfElemets /self.scrollView.customLayout.maxElements;
        if(allPages > 1 && allPages < 2) {
            self.scrollView.pager.numberOfPages = 2;
        } else {
            self.scrollView.pager.numberOfPages = allPages;
        }
    }
    // self.scrollView.pagerWidthConstraint.constant = 0;
    // [self.scrollView.pager removeFromSuperview];
    // self.scrollView.pager = nil;
    //[self insertSubview:control aboveSubview:_scrollView];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end

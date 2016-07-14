//
//  MHScrollVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHMenuViewController.h"
#import "Downloader.h"
#import "MHMenuCell.h"
#import "MHConfigure.h"
#import "MHMenuModelItem.h"

@interface MHMenuViewController () {
    BOOL _isFirst;
}

@property (assign, nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) WTURLImageViewPreset *preset;
@property (assign, nonatomic) BOOL rotateIndex;
@property (strong, nonatomic) NSIndexPath* rotateIndexPath;

@end

@implementation MHMenuViewController



-(id)init {
    self = [super init];
    if (self != nil) {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MHMenuViewController" owner:self options:nil] objectAtIndex:0];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MHMenuCell" bundle:nil] forCellWithReuseIdentifier:@"MenuCell"];//menuCell
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        self.customLayout.delegate = self;
        _initialScrollDone = NO; //remove 6
        self.preset = [WTURLImageViewPreset defaultPreset];
        WTURLImageViewOptions options = self.preset.options;
        options &= ~ (WTURLImageViewOptionShowActivityIndicator | WTURLImageViewOptionAnimateEvenCache | WTURLImageViewOptionsLoadDiskCacheInBackground);
        self.preset.options = options;
        self.preset.fillType = UIImageResizeFillTypeFitIn;
    }
    return self;
}

//- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath {
//    self.pager.currentPage = indexPath.row;
//}
- (void)currentPage:(NSInteger)page {
    self.pager.currentPage = page;
}


//- (void)viewDidLayoutSubviews {
//    
//    // If we haven't done the initial scroll, do it once.
//    if (!self.initialScrollDone) {
//        self.initialScrollDone = YES;
//        
//        [self.collectionView scrollToItemAtIndexPath:self.myInitialIndexPath
//                                    atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
//    }
//}

- (void)viewDidLayoutSubviews
{
    NSLog(@"Entered");
        if (!self.initialScrollDone) {
            self.initialScrollDone = YES;
 //   [self.collectionView layoutIfNeeded];
//    NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
//    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
  //  NSIndexPath *nextItem = [NSIndexPath indexPathForItem:self.activeIndex +2 inSection:currentItem.section];
    
  [self.collectionView scrollToItemAtIndexPath:self.activeIndex atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.activeIndex];
//            NSInteger currentIndex = cell.bounds.origin.x / self.collectionView.frame.size.width;
//            self.pager.currentPage = currentIndex;
            if(_delegate && [_delegate respondsToSelector:@selector(didSelectCell:)]) {
                [_delegate didSelectCell:self.activeIndex.item];
            }

        }
//        else if(_rotateIndex) {
//            [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//            self.rotateIndex = NO;
//        }
}

//collectionView:layout:sizeForItemAtIndexPath:
- (void) orientationChanged:(NSNotification *)note {
    UIDeviceOrientation interfaceOrientation = [[note object] orientation];
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        self.rotateIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        self.rotateIndex = YES;
        NSLog(@"Rptation");
        
        //[self.customLayout setup];
        [self.collectionView reloadData];
        [self updateAll];
        if(_delegate && [_delegate respondsToSelector:@selector(shouldUpdateHeighOfMenuContainer)]) {
            [_delegate shouldUpdateHeighOfMenuContainer];
            //[self.collectionView layoutIfNeeded];
        }

 [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//        [self.customLayout invalidateLayout];
//      [self.collectionView.collectionViewLayout invalidateLayout];
        //[[self.collectionView delegate] scrollViewDidEndDecelerating:self.collectionView];
//        [self.collectionView reloadData];
    }
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.collectionView performBatchUpdates:nil completion:nil];
//}

#pragma mark - UpdateController method

- (void)updateAll {
    self.view.backgroundColor = self.backgroundColor;
    [self updatePageControl];
//     self.automaticallyAdjustsScrollViewInsets = NO;
//    NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
  // [self.customLayout invalidateLayout];

}
//
//- (void) willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//    
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        [self.collectionView.collectionViewLayout invalidateLayout];
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {                    [self.collectionView reloadData];
//        
//    }];
//    
//}
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    // Do view manipulation here.
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    [self.collectionView reloadSections:[NSIndexSet indexSet]];
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(MHCollectionViewLayout  *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.view bounds].size;
//}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_arrayOfModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const CellIdentifier = @"MenuCell";
    
    MHMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    MHMenuModelItem *modelItem = _arrayOfModels[indexPath.item];
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil) {
        
    } else {
        if ([self.activeIndex isEqual:indexPath]) {
            [cell.imageContainer setURL:[NSURL URLWithString:modelItem.activeThumbnnailUrl] withPreset:self.preset];
        } else {
            [cell.imageContainer setURL:[NSURL URLWithString:modelItem.inActiveThumbnnailUrl] withPreset:self.preset];
        }
    }
    
    cell.cellIndex = indexPath.item;
    [cell setVisibleSplitter:indexPath.item];
    
    return cell;
    
}
//
//- (void)finishInteractiveTransition {
//    NSLog(@"Transition");
//}
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMenuCell *cell = (MHMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self collectionView:collectionView didDeselectItemAtIndexPath:self.activeIndex];
    MHMenuModelItem *modelItem = _arrayOfModels[indexPath.item];
    
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil) {
        //TO-DO
    } else {
        [cell.imageContainer setURL:[NSURL URLWithString:modelItem.activeThumbnnailUrl] withPreset:self.preset];
        
    }
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:indexPath.item];
    }
    
    self.activeIndex = indexPath;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMenuCell *cell = (MHMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MHMenuModelItem *modelItem = _arrayOfModels[indexPath.item];
    [cell.imageContainer setURL:[NSURL URLWithString:modelItem.inActiveThumbnnailUrl] withPreset:self.preset];
}

#pragma mark - ScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
    NSInteger size = [visibleItems count];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"item" ascending:YES];
    NSArray *results = [visibleItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    NSInteger visibleElement =[(NSIndexPath *)results[size -1]item] + 1;
    CGFloat allPages = visibleElement /self.customLayout.maxElements;
    CGFloat decimalPart = visibleElement % self.customLayout.maxElements;
    if(size > self.customLayout.maxElements) {
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            // moved right
            visibleElement =[(NSIndexPath *)results[0]item];
            allPages = visibleElement /self.customLayout.maxElements;
            decimalPart = visibleElement % self.customLayout.maxElements;
            if(visibleElement == self.customLayout.numberOfElemets || decimalPart == 0) {
                self.pager.currentPage = allPages;
            } else {
                
                self.pager.currentPage = allPages +1;
            }
        } else if (self.lastContentOffset > scrollView.contentOffset.x) {
            // moved left
            if([(NSIndexPath *)results[0]item] == 0) {
                self.pager.currentPage = 0;
            } else if(decimalPart > 1) {
                self.pager.currentPage = allPages;
            } else {
                self.pager.currentPage = allPages - 1;
            }
        }
    } else {
        if (decimalPart != 0) {
            self.pager.currentPage = allPages;
        } else {
            self.pager.currentPage = allPages - 1;
        }
    }
    [self.pager updateCurrentPageDisplay];
}

#pragma mark - PageControll methods

- (void)updatePageControl {
    if(self.customLayout.maxElements >= self.customLayout.numberOfElemets) {
        self.pager.hidden = YES;
    } else {
        self.pager.hidden = NO;
        self.pager.hidesForSinglePage = YES;
        self.pager.pageIndicatorTintColor = self.inactivePageDotColor;
        self.pager.currentPageIndicatorTintColor = self.activePageDotColor;
        self.pager.defersCurrentPageDisplay = YES;
        CGFloat allPages = self.customLayout.numberOfElemets /self.customLayout.maxElements;
        CGFloat decimalPart = self.customLayout.numberOfElemets % self.customLayout.maxElements;
        if(decimalPart > 0 ) {
            self.pager.numberOfPages = allPages + 1;
        } else {
            self.pager.numberOfPages = allPages;
        }
    }
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
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
       // [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        self.customLayout.delegate = self;
        _initialScrollDone = NO; //remove 6
        self.preset = [WTURLImageViewPreset defaultPreset];
        WTURLImageViewOptions options = self.preset.options;
        options |= (WTURLImageViewOptionShowActivityIndicator | WTURLImageViewOptionAnimateEvenCache | WTURLImageViewOptionsLoadDiskCacheInBackground | WTURLImageViewOptionDontClearImageBeforeLoading);
        self.preset.options = options;
        self.preset.fillType = UIImageResizeFillTypeFitIn;
    }
    return self;
}

- (void)currentPage:(NSInteger)page {
    NSLog(@"Delegate");
    self.pager.currentPage = page;
}


- (void)viewDidLayoutSubviews
{
    
    if (!self.initialScrollDone) {
        self.initialScrollDone = YES;
        
        [self.collectionView scrollToItemAtIndexPath:self.activeIndex atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        
        if(_delegate && [_delegate respondsToSelector:@selector(didSelectCell:)]) {
            [_delegate didSelectCell:self.activeIndex.item];
        }
    }
    if(self.rotateIndex) {
        self.rotateIndex = NO;
        [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        [self updateAll];
        
        if(_delegate && [_delegate respondsToSelector:@selector(shouldUpdateHeighOfMenuContainer)]) {
            [_delegate shouldUpdateHeighOfMenuContainer];
        }
    }
}


- (void) orientationChanged:(NSNotification *)note {
   UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        self.rotateIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        self.rotateIndex = YES;
        [self.collectionView reloadData];
//        
//        if(_delegate && [_delegate respondsToSelector:@selector(shouldUpdateHeighOfMenuContainer)]) {
//            [_delegate shouldUpdateHeighOfMenuContainer];
//        }
//        
//        [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//        [self updateAll];
        
    }
}

#pragma mark - UpdateController method

- (void)updateAll {
    self.view.backgroundColor = self.backgroundColor;
    [self updatePageControl];
}
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
        cell.imageContainer.hidden = YES;
        cell.textLable.hidden = NO;
        cell.textLable.text = modelItem.textForLable;
    } else {
        cell.imageContainer.hidden = NO;
        cell.textLable.hidden = YES;

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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMenuCell *cell = (MHMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self collectionView:collectionView didDeselectItemAtIndexPath:self.activeIndex];
    MHMenuModelItem *modelItem = _arrayOfModels[indexPath.item];
    
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil) {
        cell.textLable.text = @"Selected";
        
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
    
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil) {
        cell.textLable.text = modelItem.textForLable;
        
    } else {
        [cell.imageContainer setURL:[NSURL URLWithString:modelItem.inActiveThumbnnailUrl] withPreset:self.preset];
    }
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
            visibleElement =[(NSIndexPath *)results[size-1]item];
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

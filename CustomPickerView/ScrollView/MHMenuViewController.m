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


@interface MHMenuViewController ()

@property (assign, nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) WTURLImageViewPreset *preset;
@property (assign, nonatomic) BOOL rotateIndex;
@property (strong, nonatomic) NSIndexPath* rotateIndexPath;
@property (assign, nonatomic) NSInteger numberOfElements;

@end


@implementation MHMenuViewController

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self != nil) {
        self.arrayOfModels = array;
        self.numberOfElements = [MHConfigure sharedConfiguration].numberOfElements;
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MHMenuViewController" owner:self options:nil] objectAtIndex:0];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MHMenuCell" bundle:nil] forCellWithReuseIdentifier:@"MenuCell"];
        self.customLayout.delegate = self;
        [self.customLayout setup];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        self.initialScrollDone = NO;
        [self setUpWTURLImageView];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    if (!self.initialScrollDone) {
        self.initialScrollDone = YES;
        [self.collectionView scrollToItemAtIndexPath:self.activeIndex atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:)]) {
            [self.delegate didSelectCell:self.activeIndex.item];
        }
    }
    if(self.rotateIndex) {
        self.rotateIndex = NO;
        [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        [self updateAll];
        if(self.delegate && [self.delegate respondsToSelector:@selector(shouldUpdateHeighOfMenuContainer)]) {
            [self.delegate shouldUpdateHeighOfMenuContainer];
        }
    }
}

#pragma mark - SetUp WTURLImageView method

- (void)setUpWTURLImageView {
    self.preset = [WTURLImageViewPreset defaultPreset];
    WTURLImageViewOptions options = self.preset.options;
    options |= (WTURLImageViewOptionShowActivityIndicator | WTURLImageViewOptionAnimateEvenCache | WTURLImageViewOptionsLoadDiskCacheInBackground | WTURLImageViewOptionDontClearImageBeforeLoading);
    self.preset.options = options;
    self.preset.fillType = UIImageResizeFillTypeFitIn;
}

#pragma mark - Notification method

- (void)orientationChanged {
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        self.rotateIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        self.rotateIndex = YES;
        [self.collectionView reloadData];
    }
}

#pragma mark - UpdateController method

- (void)updateAll {
    self.view.backgroundColor = self.backgroundColor;
    [self updatePageControl];
}

- (void)updateAllWithoutRotation {
    self.numberOfElements = [MHConfigure sharedConfiguration].numberOfElements;
    [self.collectionView reloadData];
    if(self.activeIndex.item >= self.numberOfElements) {
        self.activeIndex = [NSIndexPath indexPathForItem:(self.numberOfElements - 1) inSection:self.activeIndex.section];
    }
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    self.rotateIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    self.rotateIndex = YES;
    if(self.rotateIndex) {
        self.rotateIndex = NO;
        [self.collectionView scrollToItemAtIndexPath:self.rotateIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        [self updateAll];
        if(self.delegate && [self.delegate respondsToSelector:@selector(shouldUpdateHeighOfMenuContainer)]) {
            [self.delegate shouldUpdateHeighOfMenuContainer];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfElements;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const CellIdentifier = @"MenuCell";
    
    MHMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    MHMenuModelItem *modelItem = self.arrayOfModels[indexPath.item];
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
    [cell setVisibleSplitter:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMenuCell *cell = (MHMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self collectionView:collectionView didDeselectItemAtIndexPath:self.activeIndex];
    MHMenuModelItem *modelItem = self.arrayOfModels[indexPath.item];
    
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil) {
        cell.textLable.text = @"Selected";
    } else {
        [cell.imageContainer setURL:[NSURL URLWithString:modelItem.activeThumbnnailUrl] withPreset:self.preset];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:)]) {
        [self.delegate didSelectCell:indexPath.item];
    }
    self.activeIndex = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMenuCell *cell = (MHMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MHMenuModelItem *modelItem = self.arrayOfModels[indexPath.item];
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
    NSInteger size = [visibleItems count];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"item" ascending:YES];
    NSArray *results = [visibleItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    NSInteger visibleElement =[(NSIndexPath *)results[size -1]item] + 1;
    CGFloat allPages = visibleElement /self.customLayout.maxElements;
    CGFloat decimalPart = visibleElement % self.customLayout.maxElements;
    if(size > self.customLayout.maxElements) {
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            visibleElement =[(NSIndexPath *)results[size-1]item];
            allPages = visibleElement /self.customLayout.maxElements;
            decimalPart = visibleElement % self.customLayout.maxElements;
            self.pager.currentPage = allPages;
        } else if (self.lastContentOffset > scrollView.contentOffset.x) {
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
        CGFloat allPages = self.customLayout.numberOfElemets / self.customLayout.maxElements;
        CGFloat decimalPart = self.customLayout.numberOfElemets % self.customLayout.maxElements;
        if(decimalPart > 0 ) {
            self.pager.numberOfPages = allPages + 1;
        } else {
            self.pager.numberOfPages = allPages;
        }
    }
}

#pragma mark - MHCollectionViewLayout Delegate method

- (void)currentPage:(NSInteger)page {
    self.pager.currentPage = page;
}

-(void) dealloc {
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

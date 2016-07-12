//
//  MHScrollVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHScrollVC.h"
#import "Downloader.h"
#import "MHMenuCell.h"
#import "MHConfigure.h"
#import "MHMenuModelItem.h"

@interface MHScrollVC () {
    BOOL _isFirst;
}
@property (strong, nonatomic) NSIndexPath *activeIndex;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) WTURLImageViewPreset *preset;


@end

@implementation MHScrollVC



-(id)init {
    self = [super init];
    if (self != nil)
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MHScrollVC" owner:self options:nil] objectAtIndex:0];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MHMenuCell" bundle:nil] forCellWithReuseIdentifier:@"MenuCell"];//menuCell
        self.view.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerBackgroundColor];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(orientationChanged:)
         name:UIDeviceOrientationDidChangeNotification
         object:[UIDevice currentDevice]];
        
        [self updatePageControl]; /// remove
        _isFirst = YES; //remove 6
        self.preset = [WTURLImageViewPreset defaultPreset];
        WTURLImageViewOptions options = self.preset.options;
        options &= ~ (WTURLImageViewOptionShowActivityIndicator | WTURLImageViewOptionAnimateEvenCache | WTURLImageViewOptionsLoadDiskCacheInBackground);
        self.preset.options = options;
        self.preset.fillType = UIImageResizeFillTypeFitIn;
    }
    return self;
}


- (void) orientationChanged:(NSNotification *)note
{
    UIDeviceOrientation interfaceOrientation = [[note object] orientation];
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [self.customLayout setup];
        [self.collectionView reloadData];
        [self updatePageControl];
        if(_delegate && [_delegate respondsToSelector:@selector(shouldUpdatePageControl)]) {
            [_delegate shouldUpdatePageControl];
        }
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arrayOfModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
              cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"MenuCell";
    
    MHMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    MHMenuModelItem *modelItem = _arrayOfModels[indexPath.item];
    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil)
    {
        
    }
    else
    {
        if ([self.activeIndex isEqual:indexPath])
        {
         [cell.imageContainer setURL:[NSURL URLWithString:modelItem.activeThumbnnailUrl] withPreset:self.preset];
          }
        else
        {
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

    if (modelItem.activeThumbnnailUrl == nil || modelItem.inActiveThumbnnailUrl == nil)
    {
        //TO-DO
    }
    else
    {
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


- (void)updatePageControl
{
    if(self.customLayout.maxElements >= self.customLayout.numberOfElemets) {
        self.pager.hidden = YES;
    } else {
        self.pager.hidden = NO;
        self.pager.hidesForSinglePage = YES;
        self.pager.pageIndicatorTintColor = [MHConfigure sharedConfiguration].inactivePageDotColor;
        self.pager.currentPageIndicatorTintColor = [MHConfigure sharedConfiguration].activePageDotColor;
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

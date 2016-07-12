//
//  MHScrollVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/12/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHScrollVC.h"
#import "Downloader.h"
#import "MHCollectionViewLayout.h"
#import "MHCollectionCell.h"
#import "MHConfigure.h"
#import "MHModelItem.h"

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
                self.swipeItems = [[NSArray alloc]initWithArray:[MHConfigure sharedConfiguration].dataSourceArray];

        _swipeModelItems = [[NSMutableDictionary alloc]init];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MHCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TestCell"];
        self.view.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerBackgroundColor];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(orientationChanged:)
         name:UIDeviceOrientationDidChangeNotification
         object:[UIDevice currentDevice]];
        [self updatePageControl];
        _isFirst = YES;
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
    return [_swipeItems count];
}

- (MHCollectionCell *)collectionView:(UICollectionView *)collectionView
              cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TestCell";
    
    MHCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *stringIndex = [NSString stringWithFormat:@"%li", (long)indexPath.item];
    MHModelItem *swipeItemView = _swipeModelItems[stringIndex];
    if (swipeItemView == nil)
    {
        swipeItemView = [[MHModelItem alloc] init];
        
        _swipeModelItems[stringIndex] = swipeItemView;
    }
    
    NSString *activeThumbnailUrl = [[MHConfigure sharedConfiguration]activeChannelLogoURL];
    NSString *thumbnailUrl = _swipeItems[indexPath.item];
    if (activeThumbnailUrl == nil || thumbnailUrl == nil)
    {
        
    }
    else
    {
        if ([self.activeIndex isEqual:indexPath])
        {
            swipeItemView.thumbnnailUrl = activeThumbnailUrl;
            [cell.imageContainer setURL:[NSURL URLWithString:activeThumbnailUrl] withPreset:self.preset];
            
        }
        else
        {
            swipeItemView.thumbnnailUrl = thumbnailUrl;
            [cell.imageContainer setURL:[NSURL URLWithString:thumbnailUrl] withPreset:self.preset];
        }
    }
    
    swipeItemView.stationID = [[MHConfigure sharedConfiguration] stationID];
    if (indexPath.item != 0) {
        swipeItemView.isSplitter = YES;
    }
    
    
    cell.cellIndex = indexPath.item;
    [cell setVisibleSplitter:indexPath.item];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHCollectionCell *cell = (MHCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self collectionView:collectionView didDeselectItemAtIndexPath:self.activeIndex];
    NSString *stringIndex = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    MHModelItem *swipeItemView = _swipeModelItems[stringIndex];
    
    NSString *activeThumbnailUrl = [[MHConfigure sharedConfiguration] activeChannelLogoURL];
    NSString *thumbnailUrl = _swipeModelItems[stringIndex];
    if (activeThumbnailUrl == nil || thumbnailUrl == nil)
    {
        
    }
    else
    {
        swipeItemView.thumbnnailUrl = activeThumbnailUrl;
        [cell.imageContainer setURL:[NSURL URLWithString:activeThumbnailUrl] withPreset:self.preset];
        
    }
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:indexPath.item];
    }
    
    self.activeIndex = indexPath;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHCollectionCell *cell = (MHCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *stringUrl = _swipeItems[indexPath.item];
    NSURL *url = [NSURL URLWithString:stringUrl];
    [cell.imageContainer setURL:url withPreset:self.preset];
}

#pragma mark - ScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
    NSInteger size = [visibleItems count];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"item"
                                                                 ascending:YES];
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

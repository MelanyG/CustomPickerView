//
//  MHCollectionViewLayout.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHCollectionViewLayout.h"
#import "MHConfigure.h"


static NSString * const kMHCollectionViewLayoutCellKind = @"MenuCell";
static CGFloat const kCollectionViewHeightConstant = 60.f;
static CGFloat const kCollectionViewItemHeightConstant = 50.f;

typedef enum {
    SwipeViewAlignmentEdge = 0,
    SwipeViewAlignmentCenter
}
SwipeViewAlignment;


@interface MHCollectionViewLayout ()

@property (nonatomic, assign) SwipeViewAlignment alignment;
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end


@implementation MHCollectionViewLayout

#pragma mark - Lifecycle

- (void)setup {
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/3, kCollectionViewItemHeightConstant);
    [self getMaxNumberOfElements];
    self.numberOfElemets = [self.collectionView numberOfItemsInSection:0];
}

- (void)prepareLayout {
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.numberOfElemets = [self.collectionView numberOfItemsInSection:0];
    [self getMaxNumberOfElements];
    NSInteger dimension = [self getDimentionToGetWidth];
    NSInteger width = dimension / self.maxElements - 0.f;
    if(self.numberOfElemets >=  self.maxElements) {
        self.itemSize = CGSizeMake(width, kCollectionViewItemHeightConstant);
        CGFloat originX = ([UIScreen mainScreen].bounds.size.width - width * self.maxElements) / 2;
        self.itemInsets = UIEdgeInsetsMake(0.0f, originX, 5.0f, 5.0f);
    } else  {
        self.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/self.numberOfElemets - self.itemInsets.left*2, kCollectionViewItemHeightConstant);
    }
    for (NSInteger item = 0; item < self.numberOfElemets; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
        cellLayoutInfo[indexPath] = itemAttributes;
    }
    newLayoutInfo[kMHCollectionViewLayoutCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemNumber = indexPath.item + self.maxElements/2;
    if(itemNumber == self.numberOfElemets) {
        itemNumber -= 1;
    } else if(itemNumber > self.numberOfElemets) {
        itemNumber = self.numberOfElemets - 1;
    }
    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:itemNumber inSection:indexPath.section];
    [self.delegate currentPage:newIndex.item / self.maxElements];
    
    return self.layoutInfo[kMHCollectionViewLayoutCellKind][newIndex];
}

#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {
    self.spacingX = self.itemInsets.left;
    CGFloat originX;
    if(indexPath.item >= self.maxElements) {
        NSInteger page = indexPath.item/self.maxElements;
        originX = floorf((self.itemSize.width) * indexPath.item) + self.itemInsets.left + _spacingX * 2 * page;
    } else {
        originX = floorf((self.itemSize.width) * indexPath.item) + self.itemInsets.left;
    }
    CGFloat originY = self.itemInsets.bottom;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    return allAttributes;
}

- (CGSize)collectionViewContentSize {
    CGFloat height = kCollectionViewHeightConstant;
    
    return CGSizeMake(self.numberOfElemets * self.itemSize.width + self.spacingX , height);
}

- (void)getMaxNumberOfElements {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.alignment = SwipeViewAlignmentCenter;
        self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPhone];
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.alignment = SwipeViewAlignmentCenter;
            self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPadPortrait];
        } else {
            self.alignment = SwipeViewAlignmentEdge;
            self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPadLandscape];
        }
    }
}

- (NSInteger)getDimentionToGetWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return [UIScreen mainScreen].bounds.size.width;
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            return [UIScreen mainScreen].bounds.size.width;
        } else {
            if(self.numberOfElemets > self.maxElements)
                return [UIScreen mainScreen].bounds.size.width;
            return [UIScreen mainScreen].bounds.size.height;
        }
    }
}

- (void)setAlignment:(SwipeViewAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
    }
}

-(void) dealloc {
    self.delegate = nil;
}

@end

//
//  MHCollectionViewLayout.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHCollectionViewLayout.h"
#import "MHConfigure.h"

static NSString * const MHCollectionViewLayoutCellKind = @"TestCell";


typedef enum
{
    SwipeViewAlignmentEdge = 0,
    SwipeViewAlignmentCenter
}
SwipeViewAlignment;

@interface MHCollectionViewLayout ()
@property (nonatomic, strong) NSArray *rotations;
@property (nonatomic, assign) SwipeViewAlignment alignment;
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation MHCollectionViewLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/3, 50.0f);
    self.interItemSpacingY = 12.0f;
    [self getMaxNumberOfElements];
    self.numberOfElemets = [MHConfigure sharedConfiguration].numberOfElements;

}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
     self.numberOfElemets = [self.collectionView numberOfItemsInSection:0];
    [self getMaxNumberOfElements];
    NSInteger dimension = [self getDimentionToGetWidth];
    NSInteger width = dimension / self.maxElements - 0.f;
    if(self.numberOfElemets >=  self.maxElements) {
        self.itemSize = CGSizeMake(width, 60.f);
        CGFloat originX = ([UIScreen mainScreen].bounds.size.width - width * self.maxElements) / 2;
        self.itemInsets = UIEdgeInsetsMake(0.0f, originX, 0.0f, 0.0f);
    } else  {
        self.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/self.numberOfElemets - self.itemInsets.left*2, 50.f);
    }
    for (NSInteger item = 0; item < self.numberOfElemets; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
         cellLayoutInfo[indexPath] = itemAttributes;
      }
    
    
    newLayoutInfo[MHCollectionViewLayoutCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}



#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    
    _spacingX = 0.f;    CGFloat originX = floorf((self.itemSize.width) * indexPath.item) + self.itemInsets.left;
    CGFloat originY =  self.itemInsets.bottom;
 
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
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

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    CGFloat height = self.itemInsets.top + rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY + self.itemInsets.bottom;
    
    return CGSizeMake(self.numberOfElemets * self.itemSize.width + _spacingX * (self.numberOfElemets) , height);
}

- (void)getMaxNumberOfElements
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.alignment = SwipeViewAlignmentCenter;
        self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPhone];
    }
    else
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.alignment = SwipeViewAlignmentCenter;
            self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPadPortrait];
            
        }
        else
        {
            self.alignment = SwipeViewAlignmentEdge;
              self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPadLandscape];
            
        }
    }
}

- (NSInteger)getDimentionToGetWidth
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
     return [UIScreen mainScreen].bounds.size.width;
    }
    else
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            return [UIScreen mainScreen].bounds.size.width;
        }
        else
        {
          return [UIScreen mainScreen].bounds.size.height;
        }
    }
}

- (void)setAlignment:(SwipeViewAlignment)alignment
{
    if (_alignment != alignment)
    {
        _alignment = alignment;
    }
}

@end

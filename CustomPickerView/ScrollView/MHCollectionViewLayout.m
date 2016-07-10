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
static NSUInteger const RotationCount = 32;
static NSUInteger const RotationStride = 3;

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
    //self.numberOfColumns = 3;
    [self getMaxNumberOfElements];
    //self.maxElements = [MHConfigure sharedConfiguration].;
    self.numberOfElemets = [MHConfigure sharedConfiguration].numberOfElements;
    // create rotations at load so that they are consistent during prepareLayout
//    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];
//    
//    CGFloat percentage = 0.0f;
//    for (NSInteger i = 0; i < RotationCount; i++) {
//        // ensure that each angle is different enough to be seen
//        CGFloat newPercentage = 0.0f;
//        do {
//            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
//        } while (fabsf(percentage - newPercentage) < 0.006);
//        percentage = newPercentage;
//        
//        CGFloat angle = 2 * M_PI * (1.0f + percentage);
//        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
//        
//        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
//    }
//    
//    self.rotations = rotations;
}

#pragma mark - Layout

- (CATransform3D)transformForAlbumPhotoAtIndex:(NSIndexPath *)indexPath
{
    
    NSInteger offset = (indexPath.section * RotationStride + indexPath.item);
    return [self.rotations[offset % RotationCount] CATransform3DValue];
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    // NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    //    for (NSInteger section = 0; section < sectionCount; section++) {
    //        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    //
    self.numberOfElemets = [self.collectionView numberOfItemsInSection:0];
    [self getMaxNumberOfElements];
    NSInteger dimension = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
    NSInteger width = dimension / self.maxElements - 0.f;
    if(self.numberOfElemets > self.maxElements) {
        self.itemSize = CGSizeMake(width, 50.f);
        self.itemInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } else  {
        self.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/self.numberOfElemets - self.itemInsets.left*2, 50.f);
       // self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    }
    //self.numberOfElemets = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger item = 0; item < self.numberOfElemets; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
        // itemAttributes.transform3D = [self transformForAlbumPhotoAtIndex:indexPath];
        cellLayoutInfo[indexPath] = itemAttributes;
        //self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
    }
    
    
    newLayoutInfo[MHCollectionViewLayoutCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}



#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    
    _spacingX = 0.f;//([[UIScreen mainScreen] bounds].size.width - self.maxElements * self.itemSize.width) / 3;
    
  //  CGFloat originX = floorf(_spacingX/2  + (self.itemSize.width + _spacingX) * indexPath.item);
    CGFloat originX = floorf((self.itemSize.width) * indexPath.item) + self.itemInsets.left;
    CGFloat originY =  self.itemInsets.bottom;
    //floor(self.itemInsets.top +
    //      (self.itemSize.height + self.interItemSpacingY) * row);
    
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
    //  self.maxElements = availableNumberOfItems;
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
            //self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
            self.maxElements = [[MHConfigure sharedConfiguration]streamPickerItemsPadLandscape];
            
        }
    }
}

- (void)setAlignment:(SwipeViewAlignment)alignment
{
    if (_alignment != alignment)
    {
        _alignment = alignment;
        //[self setNeedsLayout];
    }
}

@end

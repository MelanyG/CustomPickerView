//
//  MHCollectionViewLayout.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomViewFlowLayoutDelegate <NSObject>

/** Informs delegate about location of centered cell in grid.
 *  Delegate should use this location 'indexPath' information to
 *   adjust it's conten associated with this cell.
 *   @param indexpath of cell in collection view which is centered.
 */
- (void)currentPage:(NSInteger)page;

@end


@interface MHCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id<CustomViewFlowLayoutDelegate> delegate;
@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger maxElements;
@property (nonatomic) NSInteger numberOfElemets;
@property (nonatomic) CGFloat spacingX;

- (void)setup;

@end

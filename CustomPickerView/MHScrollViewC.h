//
//  MHScrollViewC.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHScrollView.h"

@protocol MHScrollVCProtocol <NSObject>

- (void)didSelectCell:(NSInteger)selectedCell;
- (void)shouldUpdatePageControl;

@end

@interface MHScrollViewC : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id <MHScrollVCProtocol> delegate;
@property (strong, nonatomic) NSArray *swipeItems;
@property (strong, nonatomic) NSMutableDictionary *swipeModelItems;
@property (strong, nonatomic) MHScrollView *scrollView;

-(id)initWithView:(UIView *)scroll;

@end

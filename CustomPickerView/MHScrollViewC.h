//
//  MHScrollViewC.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHScrollView.h"

@interface MHScrollViewC : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *swipeItems;
@property (strong, nonatomic) MHScrollView *scrollView;
@property (assign, nonatomic) NSInteger qtyOfItems;

-(id)initWithView:(UIView *)scroll;

@end

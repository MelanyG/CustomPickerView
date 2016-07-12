//
//  MHModelItem.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/11/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMenuModelItem : NSObject //MHmenyModelItem

@property (assign, nonatomic) NSInteger stationID;
@property (strong, nonatomic) NSString *activeThumbnnailUrl;
@property (strong, nonatomic) NSString *inActiveThumbnnailUrl;
@property (strong, nonatomic) NSString *textForLable;
@property (assign, nonatomic) BOOL isSplitter;

@end

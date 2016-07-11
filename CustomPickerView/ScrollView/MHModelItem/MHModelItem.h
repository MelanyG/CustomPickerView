//
//  MHModelItem.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/11/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHModelItem : NSObject

@property(assign, nonatomic) NSInteger stationID;
@property(strong, nonatomic) NSString *thumbnnailUrl;
@property(strong, nonatomic) NSString *callSign;

@end

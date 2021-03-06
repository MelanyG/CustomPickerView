//
//  MHConfigure.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, MHMenuItemAlignment)
{
    MHMenuItemAlignmentNone,
    MHMenuItemAlignmentBottom,
    MHMenuItemAlignmentCenter
};

@interface MHConfigure : NSObject

@property (nonatomic, assign, readonly) NSInteger streamPickerItemsPhone;
@property (nonatomic, assign, readonly) NSInteger streamPickerItemsPadPortrait;
@property (nonatomic, assign, readonly) NSInteger streamPickerItemsPadLandscape;
//@property (nonatomic, assign) NSInteger streamPickerItemsPhone;
//@property (nonatomic, assign) NSInteger streamPickerItemsPadPortrait;
//@property (nonatomic, assign) NSInteger streamPickerItemsPadLandscape;
@property (nonatomic, retain, readonly) UIColor *streamPickerBackgroundColor;
@property (nonatomic, retain, readonly) UIColor *activePageDotColor;
@property (nonatomic, retain, readonly) UIColor *inactivePageDotColor;
@property (nonatomic, assign, readonly) BOOL    streamPickerDisplaySplitters;
@property (nonatomic, retain, readonly) UIColor *streamPickerSplitterColor;
@property (nonatomic, assign, readonly) NSInteger streamPickerSplitterWidth;
@property (nonatomic, assign, readonly) NSInteger spaceBetweenStreamPickerAndContentTable;
@property (nonatomic, assign, readonly) MHMenuItemAlignment streamPickerItemAlignment;
@property (assign, nonatomic) NSInteger numberOfElements;
@property (assign, nonatomic) NSInteger maxOfElements;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (strong, nonatomic) NSString *activeChannelLogoURL;
@property (assign, nonatomic) NSInteger stationID;
@property (assign, nonatomic) NSInteger activeStation;
@property (strong, nonatomic) NSArray *accessibilityArray;

+ (MHConfigure *)sharedConfiguration;

@end

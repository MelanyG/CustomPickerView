//
//  MHConfigure.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHConfigure.h"

@interface MHConfigure ()

@property (nonatomic, assign) NSInteger streamPickerItemsPhone;
@property (nonatomic, assign) NSInteger streamPickerItemsPadPortrait;
@property (nonatomic, assign) NSInteger streamPickerItemsPadLandscape;
@property (nonatomic, retain) UIColor *streamPickerBackgroundColor;
@property (nonatomic, retain) UIColor *activePageDotColor;
@property (nonatomic, retain) UIColor *inactivePageDotColor;
@property (nonatomic, assign) BOOL streamPickerDisplaySplitters;
@property (nonatomic, retain) UIColor *streamPickerSplitterColor;
@property (nonatomic, assign) NSInteger streamPickerSplitterWidth;
@property (nonatomic, assign) NSInteger spaceBetweenStreamPickerAndContentTable;

@end


@implementation MHConfigure

static MHConfigure *singleton;

#pragma mark - Init & dealloc methods

+ (MHConfigure *)sharedConfiguration
{
    if (singleton == nil)
    {
        singleton = [MHConfigure new];
    }
    
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.streamPickerDisplaySplitters = YES;
        //colorDict = streamPickerConfigDict[@"Splitter Color"];
        self.streamPickerSplitterColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/55.0 alpha:1.0];
        self.streamPickerSplitterWidth = 2;
        self.streamPickerItemsPhone = 3;
        self.streamPickerItemsPadPortrait = 4;
        self.streamPickerItemsPadLandscape = 5;
        self.numberOfElements = 13;
        self.dataSourceArray = [[NSMutableArray alloc]init];
        for(int i=0; i<self.numberOfElements; i++) {
            if(i % 2)
                self.dataSourceArray[i] = [UIImage imageNamed:@"penguin"];
            else
                self.dataSourceArray[i] = [UIImage imageNamed:@"bird1"];
            
        }
    }
    return self;
}

@end

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
        self.streamPickerSplitterColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/55.0 alpha:1.0];
        self.streamPickerSplitterWidth = 2;
        self.streamPickerItemsPhone = 3;
        self.streamPickerItemsPadPortrait = 4;
        self.streamPickerItemsPadLandscape = 5;
        self.dataSourceArray = [[NSMutableArray alloc]initWithObjects:
                                @"https://static.pexels.com/photos/1848/nature-sunny-red-flowers.jpg",
                                @"http://all4desktop.com/data_images/original/4249535-raven.jpg",
                                @"http://all4desktop.com/data_images/original/4249168-horse.jpg",
                                @"http://all4desktop.com/data_images/original/4140623-fire-beach.jpg",
                                @"http://all4desktop.com/data_images/original/4140642-white-horse.jpg",
                                @"http://all4desktop.com/data_images/original/4140648-crisis.jpg",
                                @"http://all4desktop.com/data_images/original/4140581-nature-sail.jpg",
                                @"http://all4desktop.com/data_images/original/4140660-nfs-rivals.jpg",
                                @"http://all4desktop.com/data_images/original/4140669-far-cry-4-dead-tiger.jpg",
                                @"http://all4desktop.com/data_images/original/4140606-lake-louise-reflections.jpg",
                                @"http://all4desktop.com/data_images/original/4140722-wooden-path.jpg",
                                @"http://all4desktop.com/data_images/original/4140678-icelands-ring-road.jpg",
                                @"http://all4desktop.com/data_images/original/4140765-diver-and-the-mermaid.jpg",
                                @"http://all4desktop.com/data_images/original/4140745-denali-national-park.jpg",
                                @"http://all4desktop.com/data_images/original/4140827-hiro-in-big-hero-6.jpg",
                                @"http://all4desktop.com/data_images/original/4140837-eagle-effect-HD.jpg",
                                @"http://all4desktop.com/data_images/original/4140844-trine-underwater-scene.jpg",nil];
        self.numberOfElements = [self.dataSourceArray count];

    }
    return self;
}

@end

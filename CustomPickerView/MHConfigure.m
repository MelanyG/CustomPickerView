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
        self.streamPickerSplitterColor = [UIColor colorWithRed:200.0/255.0 green:200./255.0 blue:200./55.0 alpha:1.0];
        self.streamPickerBackgroundColor = [UIColor colorWithRed:220./255.0 green:220./255.0 blue:220./55.0 alpha:1.0];
        self.activePageDotColor = [UIColor colorWithRed:30./255.0 green:30./255.0 blue:30./55.0 alpha:1.0];
        self.inactivePageDotColor = [UIColor colorWithRed:170./255.0 green:170./255.0 blue:170./55.0 alpha:1.0];
        self.streamPickerSplitterWidth = 2;
        self.streamPickerItemsPhone = 3;
        self.streamPickerItemsPadPortrait = 4;
        self.streamPickerItemsPadLandscape = 5;
        self.stationID = 159;
        self.activeChannelLogoURL = @"http://all4desktop.com/data_images/original/4137373-mickey-mouse-carpet.jpg";
        self.dataSourceArray = [[NSMutableArray alloc]initWithObjects:
                                @"https://static.pexels.com/photos/1848/nature-sunny-red-flowers.jpg",
                                @"http://all4desktop.com/data_images/original/4249535-raven.jpg",
                                @"http://all4desktop.com/data_images/original/4249168-horse.jpg",
                                @"http://all4desktop.com/data_images/original/4140623-fire-beach.jpg",
                                @"http://all4desktop.com/data_images/original/4140642-white-horse.jpg",
//                                @"http://all4desktop.com/data_images/original/4140648-crisis.jpg",
//                                @"http://all4desktop.com/data_images/original/4140581-nature-sail.jpg",
//                                @"http://all4desktop.com/data_images/original/4140660-nfs-rivals.jpg",
//                                @"http://all4desktop.com/data_images/original/4140669-far-cry-4-dead-tiger.jpg",
//                                @"http://all4desktop.com/data_images/original/4140606-lake-louise-reflections.jpg",
//                                @"http://all4desktop.com/data_images/original/4140722-wooden-path.jpg",
//                                @"http://all4desktop.com/data_images/original/4140678-icelands-ring-road.jpg",
//                                @"http://all4desktop.com/data_images/original/4140765-diver-and-the-mermaid.jpg",
//                                @"http://all4desktop.com/data_images/original/4140745-denali-national-park.jpg",
//                                @"http://all4desktop.com/data_images/original/4140827-hiro-in-big-hero-6.jpg",
//                                @"http://all4desktop.com/data_images/original/4140837-eagle-effect-HD.jpg",
//                                @"http://all4desktop.com/data_images/original/4140844-trine-underwater-scene.jpg",
//                                @"http://all4desktop.com/data_images/original/4137380-dragon-mountains.jpg",
//                                @"http://all4desktop.com/data_images/original/4137353-sunrise-joy.jpg",
//                                @"http://all4desktop.com/data_images/original/4137364-good-morning-coffee.jpg",
//                                @"http://all4desktop.com/data_images/original/4137345-norway-aviation.jpg",
//                                @"http://all4desktop.com/data_images/original/4137391-floating-rainbow-island.jpg",
//                                @"http://all4desktop.com/data_images/original/4137428-spring-sunflower.jpg",
//                                @"http://all4desktop.com/data_images/original/4137435-sci-fi-twilight.jpg",
//                                @"http://all4desktop.com/data_images/original/4137441-gta-5-street-fight.jpg",
//                                @"http://all4desktop.com/data_images/original/4137447-tom-clancys-the-division.jpg",
//                                @"http://all4desktop.com/data_images/original/4137469-the-legend-of-zelda-ocarina-of-time.jpg",
//                                @"http://all4desktop.com/data_images/original/4137479-sunset-maui-hawaiian-island.jpg",
                                nil];
        self.numberOfElements = [self.dataSourceArray count];

    }
    return self;
}

@end

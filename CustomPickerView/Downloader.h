//
//  Downloader.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Downloader : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (strong, nonatomic)NSMutableArray *sourceData;

+ (Downloader *)sharedInstance;
-(void)downloadImages:(NSString *)url;

@end

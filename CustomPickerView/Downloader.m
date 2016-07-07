//
//  Downloader.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "Downloader.h"

@interface Downloader()

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadPhotoTask;

@end

@implementation Downloader


+ (Downloader *)sharedInstance
{
    static Downloader *_sharedInstance= nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Downloader alloc] init];
    });
    
    return _sharedInstance;
}



-(void)downloadImages:(NSString *)url {
    NSURL *urlTmp = [NSURL URLWithString:url];
    if(self.sourceData == 0) {
        self.sourceData = [[NSMutableArray alloc]init];
    }
  self.downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:urlTmp completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       [self.sourceData addObject:location];
                                                       NSLog(@"downloaded");
//                                                       UIImage *downloadedImage = [UIImage imageWithData:
//                                                                                   [NSData dataWithContentsOfURL:location]];
                                                   }];
    [self.downloadPhotoTask resume];
}



@end

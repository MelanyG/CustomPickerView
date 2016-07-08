//
//  MHCollectionCell.h
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/7/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHConfigure.h"

@interface MHCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageContainer;
@property (nonatomic) BOOL splitterWasSet;
@property (weak, nonatomic) IBOutlet UIView *splitter;


- (void)setSplitter;
@end

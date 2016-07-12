//
//  ScrollView.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MHScrollView.h"


@implementation MHScrollView


-(void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakedfrom nib");
           [self.collectionView registerNib:[UINib nibWithNibName:@"MHCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TestCell"];

}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {

            NSLog(@"init with coder");

    }
    return self;
}




@end

//
//  XImage.h
//  NSThread
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XImage : UIImage

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) NSData *imageData;

@end

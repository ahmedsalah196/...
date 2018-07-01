//
//  image.h
//  instaBugTask
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface image : NSObject
@property int height;
@property NSString *url;
@property int width;
-(int) getWidth;
-(int)getHeight;
-(NSString*) getURL;
- (instancetype)initWithData:(int)height url:(NSString *)url width:(int)width;
@end

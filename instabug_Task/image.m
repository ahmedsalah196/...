//
//  image.m
//  instaBugTask
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import "image.h"

@implementation image
- (instancetype)initWithData:(int)height url:(NSString *)url width:(int)width{
    self=[super init];
    self.height=height;
    self.width=width;
    self.url=url;
    return self;
}
- (int)getHeight{
    return self.height;
}
- (int)getWidth{
    return self.width;
}
- (NSString *)getURL{
    return self.url;
}
@end

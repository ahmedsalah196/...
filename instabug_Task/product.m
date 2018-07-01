//
//  product.m
//  instaBugTask
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import "product.h"

@implementation product
- (instancetype)initWithData:(int)Id price:(int)price prddsc:(NSString *)prddsc img:(image *)img{
    self=[super init];
    self.Id=Id;
    self.price=price;
    self.productDescription=prddsc;
    self.img=img;
    return self;
}
- (int)getId{
    return self.Id;
}
- (int)getPrice{
    return self.price;
}
- (NSString *)getDsc{
    return self.productDescription;
}
- (image *)getImg{
    return self.img;
}
@end

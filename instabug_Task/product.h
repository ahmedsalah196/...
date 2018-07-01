//
//  product.h
//  instaBugTask
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "image.h"
@interface product : NSObject
@property int Id,price;
@property NSString* productDescription;
@property image *img;
-(instancetype) initWithData:(int) Id price:(int)price prddsc:(NSString*)prddsc img:(image*)img;
-(int) getId;
-(int) getPrice;
-(NSString*) getDsc;
-(image *) getImg;
@end

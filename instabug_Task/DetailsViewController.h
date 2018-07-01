//
//  DetailsViewController.h
//  instabug_Task
//
//  Created by Ahmed Salah on 6/29/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface DetailsViewController : UIViewController

-(void) setimg:(UIImage*)img;
-(void) setprice:(NSString*) prc;
-(void) setdsc:(NSString*) dscprtn;
-(void) seturl:(NSString *) url;

@end

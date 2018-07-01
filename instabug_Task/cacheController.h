//
//  cacheController.h
//  instabug_Task
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cacheController : UIViewController

- (void)saveImage:(int)imageId img:(UIImage*)image;
- (NSString*)getfilepath:(NSString*)name;
- (NSString*)readStringFromFile;
- (void) writeStringToFile:(NSMutableArray*)mydata  dataArray: (NSMutableArray*)dataSaved;
- (void) eraseCache:(NSString *)directory;
- (UIImage*) readImage:(NSString *) URL;

@end

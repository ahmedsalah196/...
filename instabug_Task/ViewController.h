//
//  ViewController.h
//  instabug_Task
//
//  Created by Ahmed Salah on 6/28/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "cacheController.h"
#import "product.h"
#import "ViewController.h"
#import "DetailsViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSMutableArray* allProducts;
@property NSMutableDictionary* allImages;
@property int loads;
@property int index;
@property UIImage * selectedimg;
@property NSMutableArray *received;
@property NSMutableArray *dataSaved;
@property Reachability* reachability;
@property cacheController* cachecontroller;
@property NetworkStatus status;

- (void) handleNetworkChange:(NSNotification *)notice;
- (void) loadDatatoArrays;
- (void) initialize_variables;
- (void) updateAllProducts:(NSMutableArray *) mydata;
- (void)loadJSON:(NSString*)url;
- (void) loadimages: (NSMutableArray* ) receive;
- (void) updateallImages:(UIImage*)image imageIndex:(int)ind;
- (NSURLSessionTask*)createImageDownloadTask:(NSString *) URL imageIndex:(int)ind;
- ( product*) JSONObjectToProductObject:(id) JSONObject;
-(NSMutableArray*) parsedata: (NSMutableArray*)mydata;

@end

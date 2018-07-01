//
//  DetailsViewController.m
//  instabug_Task
//
//  Created by Ahmed Salah on 6/29/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextView *dsc;

@property NSString* p,*des;
@property UIImage *img;
@property NSString* imgurl;

@end

@implementation DetailsViewController
- (void)viewDidLoad {
    
    //init view data with received data.
    [super viewDidLoad];
    self.price.text=self.p;
    self.dsc.text=self.des;
    self.imageview.image=self.img;
    
    // request the image if it wasn't received before changing the view.
    if(self.img==nil){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            //init url.
            NSURL *url = [NSURL URLWithString:self.imgurl];
            NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLSessionTask* downloadTask = [session downloadTaskWithRequest:req completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
                
                //put image in the imageview.
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageview.image=image;
                        
                    });
                }
                
            }];
            [downloadTask resume];
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setimg:(UIImage *)img{
    self.img=img;
}
- (void)setprice:(NSString *)prc{
    self.p=prc;
}
- (void)setdsc:(NSString *)dscrptn{
    self.des=dscrptn;
}
-(void) seturl:(NSString *) url{
    self.imgurl=url;
}

@end

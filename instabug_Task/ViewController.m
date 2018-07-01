//
//  ViewController.m
//  instaBugTask
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import "ViewController.h"

const int ARRAY_INITIAL_SIZE=10;
const NSString* picture_extension=@"/?interview_task_mockup.png/";
@interface ViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize_variables];
    [self loadDatatoArrays];
}

//parse array of NBOjects to array of our custom class 'products.'
-(NSMutableArray*) parsedata: (NSMutableArray*)mydata{
    
    NSMutableArray* ret=[NSMutableArray arrayWithCapacity:ARRAY_INITIAL_SIZE];
    for (id current in mydata){
        
        //parse and add product to the array to be returned.
        [ret addObject:[self JSONObjectToProductObject:current]];
        
        //will be used to get the images.
        [self.received addObject:[ret lastObject]];
    }
    return ret;
}

-(product*) JSONObjectToProductObject:(id) JSONObject{
    
    //parse image data.
    image* img=[[image alloc] initWithData:[JSONObject[@"image"][@"height"] intValue] url:JSONObject[@"image"][@"url"] width:[JSONObject[@"image"][@"width"] intValue]];
    
    return [[product alloc] initWithData:[JSONObject[@"id"] intValue] price:[JSONObject[@"price"] intValue] prddsc:JSONObject[@"productDescription"] img:img];
}

-(NSURLSessionTask*)createImageDownloadTask:(NSString *) URL imageIndex:(int)ind{
    //create and init url request.
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* downloadTask = [session downloadTaskWithRequest:req completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
        
        //convert data received to image.
        NSData *imagedata=[NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:imagedata];
        
        //if image loaded successfully, cache it and add it to the dictionary.
        if ( image ) {
            [self updateallImages:image imageIndex:ind];
            //update table with pic;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }
    }];
    return downloadTask;
}

//whenever new image is inserted cache is updated.
-(void) updateallImages:(UIImage*)image imageIndex:(int)ind{
    self.allImages[@(ind)]=image;
    [self.cachecontroller saveImage:ind+1 img:image];
}

//called after parsing the json received to get the images from the received images' urls.
-(void) loadimages: (NSMutableArray* ) receive{
    
    for(id product in self.received){
        int ind=[product getId]-1;
        
        //if the image was already received don't request again. ( precaution )
        if(self.allImages[@(ind)] != nil)
            continue;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            NSString *URL=[NSString stringWithFormat:@"%@%@",[[product getImg] getURL],picture_extension];
            NSURLSessionTask *downloadTask=[self createImageDownloadTask:URL imageIndex:ind];
            [downloadTask resume];
        });
    }
}

-(void)loadJSON:(NSString*)url {
    
    //create and init url request.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    self.received=[NSMutableArray arrayWithCapacity:ARRAY_INITIAL_SIZE];
    [request setHTTPMethod:@"GET"];
    NSURL*URL=[NSURL URLWithString:url];
    [request setURL:URL];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              //extract array of objects from json data.
                                              NSError *jsonError;
                                              NSMutableArray *mydata = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
                                              
                                              if(jsonError) {
                                                  NSLog(@"json error : %@", [jsonError localizedDescription]);
                                              }
                                              
                                              else {
                                                  [self updateAllProducts:mydata];
                                                  
                                                  [self loadimages:self.received];
                                              }
                                          }];
    
    [downloadTask resume];
}

//whenever allproducts array is updated cache and tableview are updated.
-(void) updateAllProducts:(NSMutableArray *) mydata{
    NSMutableArray *parsed=[self parsedata:mydata];
    [self.allProducts addObjectsFromArray:parsed];
    
    //update cache with new data
    [self.cachecontroller writeStringToFile:mydata dataArray:self.dataSaved];
    
    //update table with text data received
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
    
}

-(void) initialize_variables{
    //initialize data.
    self.allProducts=[NSMutableArray arrayWithCapacity:ARRAY_INITIAL_SIZE];
    self.allImages=[NSMutableDictionary dictionaryWithCapacity:ARRAY_INITIAL_SIZE];
    self.dataSaved=[NSMutableArray arrayWithCapacity:ARRAY_INITIAL_SIZE];
    self.loads=0;
    
    //get current status and allow notification when it changes.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.status = [self.reachability currentReachabilityStatus];
    
    self.cachecontroller=[cacheController alloc];
}

- (void) loadDatatoArrays{
    //load cached data
    if(self.status==NotReachable){
        NSString *jsonCached = [self.cachecontroller readStringFromFile];
        NSError *jsonError;
        NSData* data = [jsonCached dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *mydata = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
        self.allProducts=[self parsedata:mydata];
        
        for(int i=0;i<[self.allProducts count];i++){
            self.allImages[@(i)]=[self.cachecontroller readImage:[NSString stringWithFormat:@"%d.png",i+1]];
        }
    }
    else {
        [self.cachecontroller eraseCache:[self.cachecontroller getfilepath:@""]];
        NSString* baseURL=[NSString stringWithFormat:@"http://grapesnberries.getsandbox.com/products?count=%d&from=%d",ARRAY_INITIAL_SIZE,self.loads*ARRAY_INITIAL_SIZE+1];
        [self loadJSON:baseURL];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.allProducts count];
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    int ind=(int)indexPath.row;
    NSString *simpleindetifier=@"SimpleIdentifier";
    
    //initialize table cell with subtitle style which allows an image and two text labels which is our case.
    UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:simpleindetifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleindetifier];
    }
    
    cell.imageView.image=self.allImages[@(ind)];
    
    product *prdct;
    prdct=[self.allProducts objectAtIndex:ind];

    //assign cell with required data.
    cell.textLabel.text=[NSString stringWithFormat:@"$ %d",[prdct getPrice]];
    cell.detailTextLabel.text=[prdct getDsc];
    
    //if the cell index is tha last element in the data available and there is internet connection
    //load more.
    if((ind==[self.allProducts count]-1) && self.status!=NotReachable){
        self.loads++;
        //start loading from the last loaded object index.
        [self loadJSON:[NSString stringWithFormat:@"http://grapesnberries.getsandbox.com/products?count=%d&from=%d",ARRAY_INITIAL_SIZE,1+self.loads*ARRAY_INITIAL_SIZE]];
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning!!!");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    DetailsViewController *details =[segue destinationViewController];
    
    product *prdct;
    prdct=[self.allProducts objectAtIndex:self.index];
    
    //set all properties of the view to be displayed.
    [details setprice:[NSString stringWithFormat:@"%d",[prdct getPrice]]];
    [details setdsc:[NSString stringWithFormat:@"%@",[prdct getDsc]]];
    [details seturl:[NSString stringWithFormat:@"%@/?interview_task_mockup.png/",[[prdct getImg] getURL]]];
    [details setimg:self.selectedimg];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //save index and image of the selected cell
    self.index=(int)indexPath.row;
    self.selectedimg=[self.tableview cellForRowAtIndexPath:indexPath].imageView.image;
    
    //change the view
    [self performSegueWithIdentifier:@"segue" sender:self];
}


- (void) handleNetworkChange:(NSNotification *)notice
{
    if([self.reachability currentReachabilityStatus] == self.status) return;
    self.status = [self.reachability currentReachabilityStatus];
    NSLog(@"status change");
    // when connection is back remove all current cache and get new data.
    if(self.status != NotReachable){
        [self.allProducts removeAllObjects];
        [self.allImages removeAllObjects];
        [self.cachecontroller eraseCache:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];

        [self initialize_variables];
        [self loadDatatoArrays];
    }
}

@end

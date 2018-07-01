//
//  cacheController.m
//  instabug_Task
//
//  Created by Ahmed Salah on 6/27/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

#import "cacheController.h"

@implementation cacheController


// called when internet connectivity is back so new cache will replace.
-(void) eraseCache:(NSString *)directory{
    
    // get documents folder directory.
    NSFileManager *filemgr=[NSFileManager defaultManager];
    NSArray *fileArray = [filemgr contentsOfDirectoryAtPath:directory error:nil];
    
    //remove all cached files in the directory.
    for (NSString *file in fileArray){
        [filemgr removeItemAtPath:[directory stringByAppendingPathComponent:file] error:NULL];
    }
}

- (void)writeStringToFile:(NSMutableArray*)mydata  dataArray: (NSMutableArray*)dataSaved{
    
    //convert array to json string.
    NSError *jsonError;;
    [dataSaved addObjectsFromArray: mydata];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSaved options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *aString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Build the path, and create if needed.
    NSString *fileAtPath=[self getfilepath:@"products.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:YES];
}

- (NSString*)readStringFromFile {
    
    NSString *fileAtPath=[self getfilepath:@"products.json"];
    
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
}

//return file path with specific name in the documents folder.
- (NSString*)getfilepath:(NSString*)name{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = name;
    return [filePath stringByAppendingPathComponent:fileName];
}

- (void)saveImage:(int)imageId img:(UIImage*)image{

    //create path to cache the image.
    NSString *fileAtPath=[self getfilepath:[NSString stringWithFormat:@"%d.png",imageId]];
    [UIImagePNGRepresentation(image) writeToFile:fileAtPath atomically:YES];
}

- (UIImage*) readImage:(NSString *) name{
    //create path and read the image
    NSString *path=[self getfilepath:name];
    //insert image to the dictionary.
    return [UIImage imageWithContentsOfFile:path];
}
@end

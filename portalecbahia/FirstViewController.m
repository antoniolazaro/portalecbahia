//
//  FirstViewController.m
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 21/11/12.
//  Copyright (c) 2012 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-243-134-2.compute-1.amazonaws.com:8080/portalECBahia/FindAllNews"];

    conteudoNews = [[NSData alloc] initWithContentsOfURL:url];
    
    //Initialize the array.
    listOfItems = [[NSMutableArray alloc] init];
    
    //Add items
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: conteudoNews options: NSJSONReadingMutableContainers error: &e];
    
    NSLog(@"#########################");
    
    for(NSDictionary * myStr in jsonArray) {
        NSString *value = myStr[@"date"];
        NSLog(@"%@",value);
        [listOfItems addObject:myStr];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

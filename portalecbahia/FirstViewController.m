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
    
    NSLog(@"%@",jsonArray);
    NSLog(@"#########################");
    
    NSArray *tweet = [jsonArray objectForKey:@"data"];
    for(NSDictionary * myStr in tweet) {
        NSLog(@"%@",myStr);
        
        [listOfItems addObject:myStr];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfItems count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    
    NSDictionary *myStr = [listOfItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [myStr objectForKey:@"title"];
    
    NSURL *url = [NSURL URLWithString:[myStr objectForKey:@"urlImage"]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.imageView.image = image;

    
    return cell;
}

@end

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
    self.tableNews.dataSource = self;
    self.tableNews.delegate = self;
	[self fetchNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchNews
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://ec2-54-243-134-2.compute-1.amazonaws.com:8080/portalECBahia/FindAllNews"]];
        
        NSError* error;
        
        news = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNews reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = NULL;
    
    
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"PrincipalNewsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
       
        
        NSArray *name = [news objectForKey:@"data"];
        
        if([name count] > 0){
            NSDictionary *new = [name objectAtIndex:indexPath.row];
            cell.textLabel.text = [new objectForKey:@"title"];
            
            NSURL *url = [NSURL URLWithString:[new objectForKey:@"urlImage"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            cell.imageView.image = imageView.image;
        }
    }
    else{
        static NSString *CellIdentifier = @"NewsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *name = [news objectForKey:@"data"];
    
        if([name count] > 0){
            NSDictionary *new = [name objectAtIndex:indexPath.row];
            NSString *dateString = [new objectForKey:@"date"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateStyle:NSDateFormatterLongStyle];
            [format setTimeStyle:NSDateFormatterNoStyle];
            NSDate *dataFormatada = [format dateFromString:dateString];
            cell.textLabel.text = dateString;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            
            cell.detailTextLabel.text = [new objectForKey:@"title"];
            NSURL *url = [NSURL URLWithString:[new objectForKey:@"urlImage"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            cell.imageView.image = imageView.image;
        }
    }
    
    
    return cell;
}


@end

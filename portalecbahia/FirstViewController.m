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
        
        NSDictionary *newsDicctionary = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        
        news = [newsDicctionary objectForKey:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNews reloadData];
        });
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"quantidade de noticias...%d",news.count);
    return news.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = NULL;
    
    
    
//    if(indexPath.row == 0){
//        static NSString *CellIdentifier = @"PrincipalNewsCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        
//        NSDictionary *new = [contentNew objectAtIndex:indexPath.row];
//        cell.textLabel.text = [new objectForKey:@"title"];
//        
//        NSURL *url = [NSURL URLWithString:[new objectForKey:@"urlImage"]];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [[UIImage alloc] initWithData:data];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        cell.imageView.image = imageView.image;
//    }else{
    
        static NSString *CellIdentifier = @"NewsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        cell.frame = CGRectMake(0,0,300,600);
    
        NSDictionary *new = [news objectAtIndex:indexPath.row];
        NSString *dateString = [new objectForKey:@"date"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *dataFormatada = [format dateFromString:dateString];
        
        [format setDateStyle:NSDateFormatterLongStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        dateString = [format stringFromDate:dataFormatada];
        
        
        cell.textLabel.text = dateString;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    
        NSLog(@"%@",[new objectForKey:@"title"]);
        NSLog(@"%d",indexPath.row);
    
    
        cell.detailTextLabel.text = [new objectForKey:@"title"];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        NSURL *url = [NSURL URLWithString:[new objectForKey:@"urlImage"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
        CGSize itemSize = CGSizeMake(75, 75);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
//    }
    
    
    return cell;
}


@end

//
//  self.m
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 19/04/13.
//  Copyright (c) 2013 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import "NewDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ImageDetailViewController.h"

@interface NewDetailViewController ()

@end

@implementation NewDetailViewController

@synthesize detailItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Vai carregar tela de detalhamento %@",[detailItem objectForKey:@"title"]);
    
    [self configureView];
    self.tableViewDetail.dataSource = self;
    self.tableViewDetail.delegate = self;
    [self.tableViewDetail reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 75;
    }else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = NULL;
    
    
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"NewsDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSString *dateString = [detailItem objectForKey:@"date"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *dataFormatada = [format dateFromString:dateString];
        
        [format setDateStyle:NSDateFormatterLongStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        dateString = [format stringFromDate:dataFormatada];
        
        
        cell.textLabel.text = dateString;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
        
        cell.detailTextLabel.text = [detailItem objectForKey:@"title"];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        
    }else{
        static NSString *CellIdentifier = @"ContentDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *htmlString= [detailItem objectForKey:@"content"];
        //[cell.textLabel setValue: htmlString forKey:@"contentToHTMLString"];
        cell.textLabel.text = htmlString;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return cell;
}

- (void)configureView
{
    if (self.detailItem) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setImageWithURL: [NSURL URLWithString:[detailItem objectForKey:@"urlImage"]]];
            
            CGSize itemSize;
            itemSize = CGSizeMake(200,300);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [imageView.image drawInRect:imageRect];
            self.imageNewDetail.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Vai chamar segue do detalhamento de imagens");
    
    if ([segue.identifier isEqualToString:@"segueImageDetail"]) {
        
        NSString *urlImagem = [detailItem objectForKey:@"urlImage"];
        
        ImageDetailViewController *imageDetailViewController = segue.destinationViewController;
        imageDetailViewController.imageNewDetailUrl = urlImagem;
        
    }
}


@end

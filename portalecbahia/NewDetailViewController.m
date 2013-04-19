//
//  self.m
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 19/04/13.
//  Copyright (c) 2013 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import "NewDetailViewController.h"

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
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    if (self.detailItem) {
        NSDictionary *new = self.detailItem;
        
        NSString *dateString = [new objectForKey:@"date"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *dataFormatada = [format dateFromString:dateString];
        
        [format setDateStyle:NSDateFormatterLongStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        dateString = [format stringFromDate:dataFormatada];
        
        self.labelDataDetail.text = dateString;
        self.labelDataDetail.font = [UIFont boldSystemFontOfSize:10];
        
        self.labelTituloDetail.text = [new objectForKey:@"title"];
        self.labelTituloDetail.font = [UIFont boldSystemFontOfSize:10];
        
      //  self.imageViewDetail = imageSelected;
        
        self.contentNewDetail.text = [new objectForKey:@"content"];
        self.contentNewDetail.font = [UIFont boldSystemFontOfSize:10];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                profileImage.image = [UIImage imageWithData:data];
//            });
//        });
    }
}

@end

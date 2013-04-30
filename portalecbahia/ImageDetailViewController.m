//
//  ImageDetailViewController.m
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 29/04/13.
//  Copyright (c) 2013 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

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
    NSLog(@"Vai carregar imagem de %@...",_imageNewDetailUrl);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageWithURL: [NSURL URLWithString:_imageNewDetailUrl]];
    
    _imageDetailFull.image = imageView.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

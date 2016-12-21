//
//  ViewController.m
//  Remmber
//
//  Created by 何锦坤 on 15/10/26.
//  Copyright © 2015年 何锦坤. All rights reserved.
//

#import "ViewController.h"
#import "HJKGridMenu.h"
#import "IntroView.h"
#import "UzysAssetsPickerController.h"
#import "Tools.h"


@interface ViewController ()<UIGestureRecognizerDelegate,HJKGridMenuDelegate,IntroViewDelegate,UzysAssetsPickerControllerDelegate>
{
    IntroView *introView;
    UzysAssetsPickerController *picker;
    int i;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.rippleImageName = [UIImage imageNamed:@"星空1.jpg"] ;
    [super viewDidLoad];
    //self.rippleImageName = @"星空2.jpg";
    picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    [self onDoneButtonPressed];
    i = 0;
   
}

-(void) viewWillAppear:(BOOL)animated
{
    i++;
    [super viewWillAppear:animated];
    //    [self cleanRipple];
    stopUdpate = NO;
    if (i == 1) {
        //self.rippleImageName = @"星空2.jpg";
        
    }
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    stopUdpate = YES;
    //    [self cleanRipple];
}

#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    
    
    UIPanGestureRecognizer  *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.enabled = YES;
    panGestureRecognizer.cancelsTouchesInView = NO;
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer  *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    singleTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    UITapGestureRecognizer  *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuhandlePanGesture:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.enabled = YES;
    doubleTapGestureRecognizer.cancelsTouchesInView = NO;
    doubleTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
}



- (void)handlePanGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:nil];
    
    [_ripple initiateRippleAtLocation:location];
}

- (void)menuhandlePanGesture:(UITapGestureRecognizer *)gesture {
   
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[HJKGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    HJKGridMenu *av = [[HJKGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(HJKGridMenu *)gridMenu willDismissWithSelectedItem:(HJKGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    switch (itemIndex) {
        case 0:
            picker.maximumNumberOfSelectionVideo = 0;
            picker.maximumNumberOfSelectionPhoto = 1;
            break;
            
        default:
            break;
    }
    
    [self presentViewController:picker animated:YES completion:^{
//        self.rippleImageName = @"星空2.jpg";
//        [self loadImageIntoPond:self.rippleImageName];
    }];

}

- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            *stop = YES;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"nowbackimg.jpg"]];   // 保存文件的名称
            [UIImagePNGRepresentation(img)writeToFile: filePath atomically:YES];
            
        }];
        
        
    }

    [self changeimg];
}

-(void)changeimg
{
    [self cleanRipple];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"nowbackimg.jpg"]];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    self.rippleImageName = savedImage;
    [self loadImageIntoPond:self.rippleImageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

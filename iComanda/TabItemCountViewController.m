//
//  TabItemCountViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabItemCountViewController.h"


@implementation TabItemCountViewController

@synthesize itemCountValue, itemLabelValue;

- (id)init{
    [super initWithNibName:nil bundle:nil];
    
    [self setTitle:@"Adicionar Item"];
    
    UIBarButtonItem *barBtnItem;
    
    //done btn
    barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(create:)];
    
    [[self navigationItem] setRightBarButtonItem:barBtnItem];
    [barBtnItem release];
    
    //cancel btn
    barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    [[self navigationItem] setLeftBarButtonItem:barBtnItem];
    
    [barBtnItem release];
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)dealloc
{
    [itemLabelText release];
    [itemLabelValue release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)removeImageViews:(UIView *)view{
    //collections of imageViews that should be removed
    NSMutableArray *imageViewsToRemove = [[NSMutableArray alloc] init];
    
    //go through subviews to collect the imageViews
    for(int index = 0; index < [[view subviews] count]; index++){
        UIView *v = [[[self view] subviews] objectAtIndex:index];
        
        //verify the time of this view
        if([v isKindOfClass:[UIImageView class]]){
            //add to the collection
            [imageViewsToRemove addObject:v];
        }
    }
    
    //remove each view from its superView
    for (UIView *v in imageViewsToRemove){
        [v removeFromSuperview];
    }
    
    [imageViewsToRemove release];
}

- (void)showCountImages{
    //create imageView object
    UIImageView *imgView;
    
    //getting the bounds and center position for the first imageView
    CGRect viewBounds = [[self view] bounds];
    CGRect frame = CGRectMake(((viewBounds.size.width/2)-36), 162, 72, 83); 
    
    //how many times I have to add imageViews? rounding up as: [(a+b-1)/b]
    int imgViewsCount = ([self itemCountValue]+4)/5;
    
    //setting the position for the first imageView if more are needed
    if (imgViewsCount > 0){
        frame.origin.x -= (imgViewsCount-1)*36;
    }
    
    //if they don't fit in the display width
    //set the first line to an upper position
    if(frame.origin.x < 1){
        frame.origin.x = 16;
        frame.origin.y -= 42;
    }
    
    for (int index = 0; index<imgViewsCount; index++) {
        
        //if this image will be displayed afther the 3rd quarter of display
        //set it to next line
        if(frame.origin.x > viewBounds.size.width*0.75){
            frame.origin.y += 84;
            frame.origin.x = 16;
        }
        
        //setting the image name
        NSString *imageName;
        if(imgViewsCount - index > 1){
            imageName = @"count_5";
        }else{
            imageName = [NSString stringWithFormat:@"count_%d", [self itemCountValue]-((imgViewsCount-1)*5)];
        }
        
        //alloc imageView
        imgView = [[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:imageName]];
        
        //adding as subview
        [[self view] addSubview:imgView];
        
        [imgView release];
        
        frame.origin.x += 72;
        
        
    }
}

- (void)updateInterface{
    //remove images to clear their positions
    [self removeImageViews:[self view]];
    
    //setting label values
    [itemLabelText setText:itemLabelValue];
    
    //create and show images
    [self showCountImages];
    
    [[self view] setNeedsDisplay];
    
}



- (IBAction)lessItems:(id)sender{
    if(itemCountValue > 0){
        itemCountValue--;
    }
    [self updateInterface];
    
}

- (IBAction)moreItems:(id)sender{
    itemCountValue++;
    [self updateInterface];
}

- (IBAction)create:(id)sender{
    [self setItemCountValue:itemCountValue];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender{
    [self setItemCountValue:oldItemCountValue];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateInterface];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [itemLabelText release];
    itemLabelText = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    oldItemCountValue = itemCountValue;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

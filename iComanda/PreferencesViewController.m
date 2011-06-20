//
//  PreferencesViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"
#import "FoursquareWebLogin.h"
#import "SBJSON.h"
#import "SBJsonParser.h"


@implementation PreferencesViewController

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    [self setTitle:@"Configurações"];
    
//    [[self tabBarItem] setTitle:@"Configurações"];
    [[self tabBarItem] setImage:[UIImage imageNamed:@"preferences"]];
    NSString *pathForSettings = [[NSBundle mainBundle] pathForResource:@"Preferences" ofType:@"plist"];
    optionsDict = [[NSDictionary alloc] initWithContentsOfFile:pathForSettings];
    NSLog(@"prefs: %@", optionsDict);
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}



Foursquare2Callback authorizeCallbackDelegate;
-(void)authorizeWithViewController:(UIViewController*)controller
						  Callback:(Foursquare2Callback)callback{
	authorizeCallbackDelegate = [callback copy];
	NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
	loginCon = [[FoursquareWebLogin alloc] initWithUrl:url];
	loginCon.delegate = self;
	loginCon.selector = @selector(setCode:);
    loginCon.selectorForCancel = @selector(stopAnimatingActivityIndicator);
	[loginCon setTitle:@"Foursquare Login"];
	[[self navigationController] pushViewController:loginCon animated:YES];
    
}

-(void)setCode:(NSString*)code{
	[Foursquare2 getAccessTokenForCode:code callback:^(BOOL success,id result){
		if (success) {
			[Foursquare2 setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
			[Foursquare2 setAccessToken:[result objectForKey:@"access_token"]];
			authorizeCallbackDelegate(YES,result);
            [authorizeCallbackDelegate release];
		}
	}];
    
}


- (void)stopAnimatingActivityIndicator{
    NSLog(@"stopAnimatingActivityIndicator called");
    [activityIndicator stopAnimating];
    [preferencesTableView reloadData];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [preferencesTableView release];
    preferencesTableView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [preferencesTableView reloadData];
    if(loginCon){
        [self stopAnimatingActivityIndicator];
        [loginCon release];
        loginCon = nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [[optionsDict allKeys] objectAtIndex:section];
    
    return key;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PrefCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSString *keyForSection = [[optionsDict allKeys] objectAtIndex:[indexPath section]];
    NSDictionary *dictForSection = [optionsDict objectForKey:keyForSection];
    
    
    NSString *cellText = [[dictForSection allKeys] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:cellText];
    
    if ([cellText isEqual:@"Connect"]){
        if ([Foursquare2 isNeedToAuthorize]) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect-white"]];
            [cell setAccessoryView:imgView];
            [imgView release];
        }else{
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
            [cell setAccessoryView:imgView];
            [imgView release];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *keyForSection = [[optionsDict allKeys] objectAtIndex:[indexPath section]];
    NSDictionary *dictForSection = [optionsDict objectForKey:keyForSection];
    
    NSString *keyForRow = [[dictForSection allKeys] objectAtIndex:[indexPath row]];
    
    if([keyForRow isEqual:@"Connect"]){
        if ([Foursquare2 isNeedToAuthorize]) {
            [self authorizeWithViewController:self 
                                     Callback:^(BOOL success,id result){
                                         if (success) {
                                             [self stopAnimatingActivityIndicator];
                                         }
                                     }];
            [activityIndicator startAnimating];
            [activityIndicator setHidden:NO];
        }else{
            [preferencesTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [Foursquare2 removeAccessToken];
        [tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [optionsDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [[optionsDict allKeys] objectAtIndex:section];
    
    return [[optionsDict objectForKey:key] count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

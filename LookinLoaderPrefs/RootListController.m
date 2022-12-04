#include "RootListController.h"

#define TWEAK_IDENTIFIER @"com.todayios-cydia.lookinloader"
#define TWEAK_NAME @"LookinLoader"
#define PREFS_CHANGED_NN @"com.todayios-cydia.lookinloader.prefschanged"
#define BUNDLE_PATH @"/Library/PreferenceBundles/LookinLoaderPrefs.bundle"
#define ICON_NAME @"icon56"

@implementation RootListController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    CGRect frame = CGRectMake(0,0,self.table.bounds.size.width,170);
    CGRect Imageframe = CGRectMake(0,10,self.table.bounds.size.width,80);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor colorWithRed: 0.38 green: 0.38 blue: 0.38 alpha: 1.00];
    
    
    UIImage *headerImage = [[UIImage alloc]
                            initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLE_PATH] pathForResource:ICON_NAME ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Imageframe];
    [imageView setImage:headerImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:imageView];
    
    CGRect labelFrame = CGRectMake(0,imageView.frame.origin.y + 90 ,self.table.bounds.size.width,80);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [headerLabel setText:TWEAK_NAME];
    [headerLabel setFont:font];
    [headerLabel setTextColor:[UIColor blackColor]];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setContentMode:UIViewContentModeScaleAspectFit];
    [headerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:headerLabel];
    
    self.table.tableHeaderView = headerView;
    
    self.respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(_reallyRespring)];
    self.navigationItem.rightBarButtonItem = self.respringBtn;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];

        //Manage Apps
        PSSpecifier *manageAppsGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Apps" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [manageAppsGroupSpec setProperty:@"Changing apps filter mode requires a respring." forKey:@"footerText"];
        [rootSpecifiers addObject:manageAppsGroupSpec];
        
        PSSpecifier *altListSpec = [PSSpecifier preferenceSpecifierNamed:@"Manage Apps" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NSClassFromString(@"ATLApplicationListMultiSelectionController") cell:PSLinkListCell edit:nil];
        [altListSpec setProperty:TWEAK_IDENTIFIER forKey:@"defaults"];
        [altListSpec setProperty:@"Manage Apps" forKey:@"label"];
        [altListSpec setProperty:@[
            @{@"sectionType":@"Visible"},
        ] forKey:@"sections"];
        [altListSpec setProperty:@"selectedApplications" forKey:@"key"];
        [altListSpec setProperty:@NO forKey:@"defaultApplicationSwitchValue"];
        [altListSpec setProperty:@YES forKey:@"useSearchBar"];
        [altListSpec setProperty:@YES forKey:@"hideSearchBarWhileScrolling"];
        [altListSpec setProperty:@YES forKey:@"alphabeticIndexingEnabled"];
        [altListSpec setProperty:@YES forKey:@"includeIdentifiersInSearch"];
        [rootSpecifiers addObject:altListSpec];
        
        // PSSpecifier *appsFilterSelectionSpec = [PSSpecifier preferenceSpecifierNamed:@"Apps Filter" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSegmentCell edit:nil];
        // [appsFilterSelectionSpec setValues:@[@0, @1] titles:@[@"Whitelist", @"Blacklist"]];
        // [appsFilterSelectionSpec setProperty:@0 forKey:@"default"];
        // [appsFilterSelectionSpec setProperty:@"appsFilter" forKey:@"key"];
        // [appsFilterSelectionSpec setProperty:TWEAK_IDENTIFIER forKey:@"defaults"];
        // [appsFilterSelectionSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        // [rootSpecifiers addObject:appsFilterSelectionSpec];
        
        //blank
        PSSpecifier *blankSpecGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:blankSpecGroup];
        
        //Contact
        PSSpecifier *contactGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Contact" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:contactGroupSpec];
        
        //Twitter
        PSSpecifier *twitterSpec = [PSSpecifier preferenceSpecifierNamed:@"Twitter" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [twitterSpec setProperty:@"Twitter" forKey:@"label"];
        [twitterSpec setButtonAction:@selector(twitter)];
        [twitterSpec setProperty:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Twitter.png",BUNDLE_PATH]] forKey:@"iconImage"];
        [rootSpecifiers addObject:twitterSpec];
        
        //manajay
        PSSpecifier *createdByGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [createdByGroupSpec setProperty:@"Created by manajay" forKey:@"footerText"];
        [createdByGroupSpec setProperty:@1 forKey:@"footerAlignment"];
        [rootSpecifiers addObject:createdByGroupSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/manajay_dlj"] options:@{} completionHandler:nil];
}

-(void)_reallyRespring{
    NSURL *relaunchURL = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",TWEAK_NAME]];
    SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:4 targetURL:relaunchURL];
    [[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

@end
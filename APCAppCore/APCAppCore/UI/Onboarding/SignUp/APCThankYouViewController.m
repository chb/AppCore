// 
//  APCThankYouViewController.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
#import "APCThankYouViewController.h"
#import "APCOnboardingManager.h"
#import "APCDataSubstrate.h"
#import "APCButton.h"
#import "APCConstants.h"
#import "APCUser.h"

#import "APCAppDelegateTasks.h"


@implementation APCThankYouViewController

@synthesize stepProgressBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (APCOnboarding *)onboarding {
    return [(id<APCOnboardingManagerProvider>)[UIApplication sharedApplication].delegate onboardingManager].onboarding;
}

- (id<APCUser>)user {
    return [(id<APCOnboardingManagerProvider>)[UIApplication sharedApplication].delegate onboardingManager].user;
}

- (IBAction)next:(APCButton *)__unused sender {
    if (self.emailVerified) {
        [self performSelector:@selector(setUserSignedIn) withObject:nil afterDelay:0.4];
    } else {
        [self finishOnboarding];
    }
}

- (void)finishOnboarding {
    if ([self onboarding].taskType == kAPCOnboardingTaskTypeSignIn) {
        // We are posting this notification after .4 seconds delay, because we need to display the progress bar completion animation
        [self performSelector:@selector(setUserSignedIn) withObject:nil afterDelay:0.4];
    } else{
        [self performSelector:@selector(setUserSignedUp) withObject:nil afterDelay:0.4];
    }
}

- (void)setUserSignedUp {
    self.user.signedUp = YES;
}

- (void)setUserSignedIn {
    self.user.signedIn = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)APCUserSignedInNotification object:nil];
	
	id<APCOnboardingTasks> appDelegate = (id<APCOnboardingTasks>)[UIApplication sharedApplication].delegate;
	if ([appDelegate respondsToSelector:@selector(afterOnBoardProcessIsFinished)]) {
		[appDelegate performSelector:@selector(afterOnBoardProcessIsFinished)];
	}
}

@end

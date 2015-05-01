// 
//  APCOnboarding.m 
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
 
#import "APCOnboarding.h"
#import "APCLog.h"
#import "NSBundle+Helper.h"

#import <ResearchKit/ResearchKit.h>

NSString * const kOnboardingStoryboardName = @"APCOnboarding";

@interface APCOnboarding ()

@property (nonatomic, readwrite) APCOnboardingTask *onboardingTask;

@property (nonatomic, readwrite) APCOnboardingTaskType taskType;;

@end

@implementation APCOnboarding

- (instancetype)initWithDelegate:(id)object taskType:(APCOnboardingTaskType)taskType
{
    self = [super init];
    if (self) {
        _taskType = taskType;
        
        if (taskType == kAPCOnboardingTaskTypeSignIn) {
            _onboardingTask = [APCSignInTask new];
        }
		else {
            _onboardingTask = [APCSignUpTask new];
        }
        
        _sceneData = [NSMutableDictionary new];
        
        _delegate = object;
        _onboardingTask.delegate = object;
    }
    
    return self;
}


/** Lazy getter for our scenes: asks the delegate for scenes if it hasn't done so yet. */
- (NSMutableDictionary *)scenes
{
    if (!_scenes) {
		self.scenes = [[self prepareScenes] mutableCopy] ?: [NSMutableDictionary dictionaryWithCapacity:1];
    }
	return _scenes;
}

- (NSDictionary *)prepareScenes
{
	NSMutableDictionary *scenes = [NSMutableDictionary new];
	
	APCScene *signUp = [self.delegate onboarding:self sceneOfType:kAPCSignUpInclusionCriteriaStepIdentifier];
	if (signUp) {
		scenes[kAPCSignUpInclusionCriteriaStepIdentifier] = signUp;
	}
	
	APCScene *eligible = [self.delegate onboarding:self sceneOfType:kAPCSignUpEligibleStepIdentifier];
	if (eligible) {
		scenes[kAPCSignUpEligibleStepIdentifier] = eligible;
	}
	
	APCScene *ineligible = [self.delegate onboarding:self sceneOfType:kAPCSignUpIneligibleStepIdentifier];
	if (ineligible) {
		scenes[kAPCSignUpIneligibleStepIdentifier] = ineligible;
	}
	
	APCScene *permissionPriming = [self.delegate onboarding:self sceneOfType:kAPCSignUpPermissionsPrimingStepIdentifier];
	if (permissionPriming) {
		scenes[kAPCSignUpPermissionsPrimingStepIdentifier] = permissionPriming;
	}
	
	APCScene *generalInfo = [self.delegate onboarding:self sceneOfType:kAPCSignUpGeneralInfoStepIdentifier];
	if (generalInfo) {
		scenes[kAPCSignUpGeneralInfoStepIdentifier] = generalInfo;
	}
	
	APCScene *medical = [self.delegate onboarding:self sceneOfType:kAPCSignUpMedicalInfoStepIdentifier];
	if (medical) {
		scenes[kAPCSignUpMedicalInfoStepIdentifier] = medical;
	}
	
	APCScene *custom = [self.delegate onboarding:self sceneOfType:kAPCSignUpCustomInfoStepIdentifier];
	if (custom) {
		scenes[kAPCSignUpCustomInfoStepIdentifier] = custom;
	}
	
	APCScene *passcode = [self.delegate onboarding:self sceneOfType:kAPCSignUpPasscodeStepIdentifier];
	if (passcode) {
		scenes[kAPCSignUpPasscodeStepIdentifier] = passcode;
	}
	
	APCScene *permissions = [self.delegate onboarding:self sceneOfType:kAPCSignUpPermissionsStepIdentifier];
	if (permissions) {
		scenes[kAPCSignUpPermissionsStepIdentifier] = permissions;
	}
	
	APCScene *thankYou = [self.delegate onboarding:self sceneOfType:kAPCSignUpThankYouStepIdentifier];
	if (thankYou) {
		scenes[kAPCSignUpThankYouStepIdentifier] = thankYou;
	}
	
	APCScene *signIn = [self.delegate onboarding:self sceneOfType:kAPCSignInStepIdentifier];
	if (signIn) {
		scenes[kAPCSignInStepIdentifier] = signIn;
	}
	
	return scenes;
}

- (UIViewController *)nextScene
{
    ORKTaskResult *result = nil;
    self.currentStep = [self.onboardingTask stepAfterStep:self.currentStep withResult:result];
	
    UIViewController *nextViewController = [self viewControllerForSceneIdentifier:self.currentStep.identifier];
	
    return nextViewController;
}

- (void)popScene
{
    ORKTaskResult *result = nil;
    if (![self.currentStep.identifier isEqualToString:kAPCSignUpMedicalInfoStepIdentifier]) {
        self.currentStep = [self.onboardingTask stepBeforeStep:self.currentStep withResult:result];
    }
}

- (UIViewController *)viewControllerForSceneIdentifier:(NSString *)identifier
{
    APCScene *scene = self.scenes[identifier];
	if (!scene) {
		APCLogDebug(@"I do not have a scene with identifier \"%@\"", identifier);
		return nil;
	}
    UIViewController *viewController = [[UIStoryboard storyboardWithName:scene.storyboardName bundle:scene.bundle] instantiateViewControllerWithIdentifier:scene.name];
    return viewController;
}

- (void)setScene:(APCScene *)scene forIdentifier:(NSString *)identifier
{
    [self.scenes setObject:scene forKey:identifier];
}

@end


@implementation APCScene

- (nonnull instancetype)initWithName:(NSString *)name inStoryboard:(NSString *)storyboardName
{
	NSParameterAssert([name length] > 0);
	NSParameterAssert([storyboardName length] > 0);
    self = [super init];
    if (self) {
        self.name = name;
		self.storyboardName = storyboardName;
    }
    return self;
}

- (nonnull NSBundle *)bundle
{
	if (!_bundle) {
		self.bundle = [NSBundle bundleForClass:[self class]];
	}
	return _bundle;
}

@end

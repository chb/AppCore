//
//  APCConsentManager.m
//  APCAppCore
//
//  Copyright (c) 2015, Apple, Inc. All rights reserved.
//  Copyright (c) 2015, Boston Children's Hospital. All rights reserved.
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

#import "APCConsentManager.h"
#import <ResearchKit/ResearchKit.h>


@implementation APCConsentManager


- (NSString *)configurationFileName
{
    return @"APHConsentSection";        // Keeping "APH" to not break backwards compatibility, should be "APC"
}

- (NSArray *)consentSectionsAndHtmlContent:(NSString **)htmlContent
{
    ORKConsentSectionType(^toSectionType)(NSString*) = ^(NSString* sectionTypeName) {
        ORKConsentSectionType   sectionType = ORKConsentSectionTypeCustom;
        
        if ([sectionTypeName isEqualToString:@"overview"]) {
            sectionType = ORKConsentSectionTypeOverview;
        } else if ([sectionTypeName isEqualToString:@"privacy"]) {
            sectionType = ORKConsentSectionTypePrivacy;
        } else if ([sectionTypeName isEqualToString:@"dataGathering"]) {
            sectionType = ORKConsentSectionTypeDataGathering;
        } else if ([sectionTypeName isEqualToString:@"dataUse"]) {
            sectionType = ORKConsentSectionTypeDataUse;
        } else if ([sectionTypeName isEqualToString:@"timeCommitment"]) {
            sectionType = ORKConsentSectionTypeTimeCommitment;
        } else if ([sectionTypeName isEqualToString:@"studySurvey"]) {
            sectionType = ORKConsentSectionTypeStudySurvey;
        } else if ([sectionTypeName isEqualToString:@"studyTasks"]) {
            sectionType = ORKConsentSectionTypeStudyTasks;
        } else if ([sectionTypeName isEqualToString:@"withdrawing"]) {
            sectionType = ORKConsentSectionTypeWithdrawing;
        } else if ([sectionTypeName isEqualToString:@"custom"]) {
            sectionType = ORKConsentSectionTypeCustom;
        } else if ([sectionTypeName isEqualToString:@"onlyInDocument"]) {
            sectionType = ORKConsentSectionTypeOnlyInDocument;
        }
        
        return sectionType;
    };
    
    NSString *kDocumentHtml        = @"htmlDocument";
    NSString *kConsentSections     = @"sections";
    NSString *kSectionType         = @"sectionType";
    NSString *kSectionTitle        = @"sectionTitle";
    NSString *kSectionFormalTitle  = @"sectionFormalTitle";
    NSString *kSectionSummary      = @"sectionSummary";
    NSString *kSectionContent      = @"sectionContent";
    NSString *kSectionHtmlContent  = @"sectionHtmlContent";
    NSString *kSectionImage        = @"sectionImage";
    NSString *kSectionAnimationUrl = @"sectionAnimationUrl";
    
    NSString *resource = [[NSBundle bundleForClass:[self class]] pathForResource:[self configurationFileName] ofType:@"json"];
    NSAssert(resource, @"Unable to locate file \"%@.json\" with Consent Section data in bundle, as defined in `configurationFileName`", [self configurationFileName]);
    
    NSData *consentSectionData = [NSData dataWithContentsOfFile:resource];
    NSAssert(consentSectionData, @"Unable to create NSData with Consent Section data");
    
    NSError *error             = nil;
    NSDictionary *consentParameters = [NSJSONSerialization JSONObjectWithData:consentSectionData options:NSJSONReadingMutableContainers error:&error];
    NSAssert(consentParameters, @"badly formed Consent Section data - error", error);
    
    NSString *documentHtmlContent = consentParameters[kDocumentHtml];
    NSAssert(documentHtmlContent == nil || documentHtmlContent && [documentHtmlContent isKindOfClass:[NSString class]], @"Improper Document HTML Content type");
    
    if (documentHtmlContent != nil && htmlContent != nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:documentHtmlContent ofType:@"html" inDirectory:@"HTMLContent"];
        NSAssert(path != nil, @"Unable to locate HTML file: %@", documentHtmlContent);
        
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        NSAssert(content != nil, @"Unable to load content of file \"%@\": %@", path, error);
        
        *htmlContent = content;
    }
    
    NSArray *parametersConsentSections = consentParameters[kConsentSections];
    NSAssert(parametersConsentSections != nil && [parametersConsentSections isKindOfClass:[NSArray class]], @"Badly formed Consent Section data");
    
    NSMutableArray *consentSections = [NSMutableArray arrayWithCapacity:parametersConsentSections.count];
    
    for (NSDictionary *section in parametersConsentSections) {
        //  Custom types do not have predefined title, summary, content, or animation
        NSAssert([section isKindOfClass:[NSDictionary class]], @"Improper section type");
        
        NSString *typeName = section[kSectionType];
        NSAssert(typeName != nil && [typeName isKindOfClass:[NSString class]], @"Missing Section Type or improper type");
        
        ORKConsentSectionType   sectionType = toSectionType(typeName);
        
        NSString *title        = section[kSectionTitle];
        NSString *formalTitle  = section[kSectionFormalTitle];
        NSString *summary      = section[kSectionSummary];
        NSString *content      = section[kSectionContent];
        NSString *htmlContent  = section[kSectionHtmlContent];
        NSString *image        = section[kSectionImage];
        NSString *animationUrl = section[kSectionAnimationUrl];
        
        NSAssert(title        == nil || title         != nil && [title isKindOfClass:[NSString class]],        @"Missing Section Title or improper type");
        NSAssert(formalTitle  == nil || formalTitle   != nil && [formalTitle isKindOfClass:[NSString class]],  @"Missing Section Formal title or improper type");
        NSAssert(summary      == nil || summary       != nil && [summary isKindOfClass:[NSString class]],      @"Missing Section Summary or improper type");
        NSAssert(content      == nil || content       != nil && [content isKindOfClass:[NSString class]],      @"Missing Section Content or improper type");
        NSAssert(htmlContent  == nil || htmlContent   != nil && [htmlContent isKindOfClass:[NSString class]],  @"Missing Section HTML Content or improper type");
        NSAssert(image        == nil || image         != nil && [image isKindOfClass:[NSString class]],        @"Missing Section Image or improper typte");
        NSAssert(animationUrl == nil || animationUrl  != nil && [animationUrl isKindOfClass:[NSString class]], @"Missing Animation URL or improper type");
        
        ORKConsentSection *section = [[ORKConsentSection alloc] initWithType:sectionType];
        section.title = title;
        section.formalTitle = formalTitle;
        section.summary = summary;
        section.content = content;
        
        if (htmlContent != nil) {
            NSString *path = [[NSBundle mainBundle] pathForResource:htmlContent ofType:@"html" inDirectory:@"HTMLContent"];
            NSAssert(path, @"Unable to locate HTML file: %@", htmlContent);
            
            NSError *error = nil;
            NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            
            NSAssert(content, @"Unable to load content of file \"%@\": %@", path, error);
            section.htmlContent = content;
        }
        if (image != nil) {
            section.customImage = [UIImage imageNamed:image];
            NSAssert(section.customImage != nil, @"Unable to load image: %@", image);
        }
        if (animationUrl != nil) {
            NSString *nameWithScaleFactor = animationUrl;
            if ([[UIScreen mainScreen] scale] >= 3) {
                nameWithScaleFactor = [nameWithScaleFactor stringByAppendingString:@"@3x"];
            } else {
                nameWithScaleFactor = [nameWithScaleFactor stringByAppendingString:@"@2x"];
            }
            NSURL *url = [[NSBundle mainBundle] URLForResource:nameWithScaleFactor withExtension:@"m4v"];
            NSError *error = nil;
            
            NSAssert([url checkResourceIsReachableAndReturnError:&error], @"Animation file--%@--not reachable: %@", animationUrl, error);
            section.customAnimationURL = url;
        }
        
        [consentSections addObject:section];
    }
    
    return consentSections;
}


@end

//
//  OAuthChallengeGenerator.h
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OAuthChallengeGenerator : NSObject
@property (readonly, strong, nonatomic) NSString *verifier;
@property (readonly, strong, nonatomic) NSString *challenge;
@property (readonly, strong, nonatomic) NSString *method;

- (instancetype)init;
- (instancetype)initWithVerifier:(NSData *)verifier;

@end
NS_ASSUME_NONNULL_END

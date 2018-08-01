//
//  OAuthChallengeGenerator.m
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

#import "OAuthChallengeGenerator.h"
#import <CommonCrypto/CommonCrypto.h>

const NSUInteger kVerifierSize = 32;

@implementation OAuthChallengeGenerator

- (instancetype)init {
    NSMutableData *data = [NSMutableData dataWithLength:kVerifierSize];
    int result __attribute__((unused)) = SecRandomCopyBytes(kSecRandomDefault, kVerifierSize, data.mutableBytes);
    return [self initWithVerifier:data];
}

- (instancetype)initWithVerifier:(NSData *)verifier {
    self = [super init];
    if (self) {
        _verifier = [[[[verifier base64EncodedStringWithOptions:0]
                       stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
                      stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
                     stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        _method = @"S256";
    }
    return self;
}

- (NSString *)challenge {
    CC_SHA256_CTX ctx;
    
    uint8_t * hashBytes = malloc(CC_SHA256_DIGEST_LENGTH * sizeof(uint8_t));
    memset(hashBytes, 0x0, CC_SHA256_DIGEST_LENGTH);
    
    NSData *valueData = [self.verifier dataUsingEncoding:NSUTF8StringEncoding];
    
    CC_SHA256_Init(&ctx);
    CC_SHA256_Update(&ctx, [valueData bytes], (CC_LONG)[valueData length]);
    CC_SHA256_Final(hashBytes, &ctx);
    
    NSData *hash = [NSData dataWithBytes:hashBytes length:CC_SHA256_DIGEST_LENGTH];
    
    if (hashBytes) {
        free(hashBytes);
    }
    
    return [[[[hash base64EncodedStringWithOptions:0]
              stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
            stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
}
@end

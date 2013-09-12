//
//  HukkController.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/8/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "HukkDataController.h"
#import "Product.h"
#import "NSString+Encode.h"
#import "ProductInstance.h"
#import "Price.h"
#import "ProductAttribute.h"

#define hukkApiUrl(method)  [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hukkster.com/%@",method]];


@interface HukkDataController()
-(void)sectionsForHukkHTTPResponse:(NSData *)data error:(NSError *)error;
-(NSArray *)extractProductAttributes:(NSArray *)productInstances;
@end

@implementation HukkDataController

-(void)sectionsForHukk:(Product *)product{
    [self sectionsForHukkUrl:product.url];
}

-(void)sectionsForHukkUrl:(NSString *)productUrl{
    [self showLoaderWithMessage:@"Waiting product sections to load"];
    NSString *encodeUrl = [productUrl encodeString:NSUTF8StringEncoding];
    NSLog(@"******* ENCODE URL:%@", encodeUrl);
    NSString *method = [NSString stringWithFormat:@"find?url=%@", encodeUrl];
    NSLog(@"encode api method: %@", method);
    
    NSMutableURLRequest *request = [self getHukkRequestWithMethod:method];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               [self sectionsForHukkHTTPResponse:data error:error];
                           }];

}

-(NSMutableURLRequest *) getHukkRequestWithMethod:(NSString *)method{
    
    NSURL *url = hukkApiUrl(method);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

#pragma mark - Private API - Repsonse methods

-(void)sectionsForHukkHTTPResponse:(NSData *)data error:(NSError *)error{
    @try {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
        if(status == 200){ // ok
            NSArray *jsonProducts = [self contentFromResponse:data andError:error];
            NSMutableArray *products = [[NSMutableArray alloc]init];
            for (int i = 0; i<jsonProducts.count; i++) {
                NSDictionary *dic = [jsonProducts objectAtIndex:i];
                ProductInstance *product = [[ProductInstance alloc]init];
                product.original_price = [[Price alloc]init];
                product.original_price.value = [[dic objectForKey:@"value"]decimalValue];
                product.product_id = [dic objectForKey:@"product_id"];
                product.selections = [dic objectForKey:@"selections"];
                product.url = [dic objectForKey:@"url"];
                product.image = [dic objectForKey:@"image"];
                product.title = [dic objectForKey:@"title"];
                product.promos = [dic objectForKey:@"promos"];
                product.local_id = [dic objectForKey:@"local_id"];
                product.current_price = [[Price alloc]init];
                product.current_price.value = [[dic objectForKey:@"value"]decimalValue];
                product.promos = [dic objectForKey:@"promos"];
                product.store = [dic objectForKey:@"store"];
                if([dic.allKeys containsObject:@"sold"]){
                    product.sold_out = [[dic objectForKey:@"S"]boolValue];
                }
                [products addObject:product];
            }
            NSDictionary *sel = (NSDictionary *)[self extractProductAttributes:[NSArray arrayWithArray:products]];
            [self.hukkDelegate sectionsForHukkResponse:sel];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [self removeLoader];
    }
}

-(NSDictionary *)extractProductAttributes:(NSArray *)productInstances{
    NSMutableDictionary *uniqueAttributes = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i<productInstances.count; i++) {
        ProductInstance *p = [productInstances objectAtIndex:i];
        for(int j = 0;j<[p.selections allKeys].count; j++){
            NSString *attributeName = [[p.selections allKeys]objectAtIndex:j];
            NSString *attributeValue = [p.selections objectForKey:attributeName];
            // check if attribute with this name already exist
            if(![[uniqueAttributes allKeys] containsObject:attributeName]){
                ProductAttribute *a = [[ProductAttribute alloc]init];
                a.name = attributeName;
                a.selections = [[NSMutableArray alloc]init];
                [uniqueAttributes setObject:a forKey:attributeName];
            }
            ProductAttribute *att = [uniqueAttributes objectForKey:attributeName];
            if(![att.selections containsObject:attributeValue]){
                [att.selections addObject:attributeValue];
            }
        }
    }
    for(int i = 0;i<uniqueAttributes.allKeys.count;i++){
        NSString *attributeName = [[uniqueAttributes allKeys]objectAtIndex:i];
        NSLog(@"SECTION %@",attributeName);
        ProductAttribute *att = [   uniqueAttributes objectForKey:attributeName];
        for (int j = 0; j<att.selections.count; j++) {
            NSLog(@"sel: %@",[att.selections objectAtIndex:j]);
        }
    }
    return uniqueAttributes;
}
@end

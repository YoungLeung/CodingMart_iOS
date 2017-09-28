//
//  CodingSetting.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/9/28.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodingSetting : NSObject
@property (strong, nonatomic) NSNumber *project_publish_payment;
@property (strong, nonatomic) NSString *project_publish_payment_color, *project_publish_payment_tip, *project_publish_payment_deadline;

@property (strong, nonatomic) NSNumber *code_wechat_app_quote_owner_id, *max_apply_size, *max_project_apply_price, *max_project_apply_size, *project_publish_payment_original, *user_identity_template_id;
@end


//
//  YixiangView.m
//  SaleManagement
//
//  Created by feixiang on 2017/7/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "YixiangView.h"

@implementation YixiangView
{
    float gao;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic andflag:(BOOL)isflag
{
    self = [super initWithFrame:frame];
    if (isflag) {
        [self.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:1 andColorString:@"999999"]];
    }
   
      if (self)
      {
          gao = 10.0f;
          NSArray *items = @[@"联系人:",@"职 位:",@"手 机:",@"固 话:",@"邮 箱:",@"行 业:",@"地 址:",@"详细地址:"];
          for (int i = 0; i < items.count; i++)
          {
              UILabel *nameL = [[UILabel alloc] init];
              nameL.text = [items objectAtIndex:i];
            
              nameL.textColor = [ToolList getColor:@"7d7d7d"];
              nameL.font = [UIFont systemFontOfSize:13];
             
              [self addSubview:nameL];
              
              UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(70, i*45, __MainScreen_Width-70, 45)];
            
              content.textColor = [ToolList getColor:@"7d7d7d"];
              content.font = [UIFont systemFontOfSize:13];
              [self addSubview:content];
             nameL.numberOfLines = 2;
             content.numberOfLines = 2;
              
              
              if (nameL.text.length < 5 ) {
                  nameL.frame = CGRectMake(10, gao, 45, 45);
                  content.frame = CGRectMake(55, gao, __MainScreen_Width-55, 45);
              }else{
                  nameL.frame = CGRectMake(10, gao, 60, 45);
                  content.frame = CGRectMake(70, gao, __MainScreen_Width-70, 45);
              }
              switch (i) {
                  case 0:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"linkmanName"]];
                      break;
                  }
                  case 1:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"position"]];

                      break;
                  }
                  case 2:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"mobile"]];

                      break;
                  }
                  case 3:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"tel"]];

                      break;
                  }
                  case 4:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"email"]];

                      break;
                  }
                  case 5:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"industryName"]];

                      break;
                  }
                  case 6:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"address"]];

                      break;
                  }
                  case 7:
                  {
                      content.text = [ToolList changeNull:[dic objectForKey:@"addressDetail"]];

                      break;
                  }
              }
              
              CGRect contentRect = [content.text  boundingRectWithSize:CGSizeMake(content.frame.size.width ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}context:nil];
           
             content.frame = CGRectMake(content.frame.origin.x, gao, content.frame.size.width, contentRect.size.height+10);
             nameL.frame = CGRectMake(10, gao,  nameL.frame.size.width, contentRect.size.height+10);
              
              gao += contentRect.size.height+10;
          }
         if([[dic objectForKey:@"intentionalProductsList"] count])
         {
             for (int i = 0; i < [[dic objectForKey:@"intentionalProductsList"] count]; i++)
             {
                 
                 gao += 10;
                [self.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(10, gao ) toPoint:CGPointMake(__MainScreen_Width-40, gao ) andWeight:0.8 andColorString:@"E7E7EB"]];
                 gao += 10;

                 NSDictionary *dic1 = [[dic objectForKey:@"intentionalProductsList"] objectAtIndex:i];
                 
                 UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(10,gao , 70, 45)];
                 nameL.textColor = [ToolList getColor:@"7d7d7d"];
                 nameL.font = [UIFont systemFontOfSize:13];
             
                 [self addSubview:nameL];
                 UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(70,gao , __MainScreen_Width-70, 45)];
              
                 content.textColor = [ToolList getColor:@"7d7d7d"];
                 content.font = [UIFont systemFontOfSize:13];
                 [self addSubview:content];
                 nameL.numberOfLines = 1;
                 content.numberOfLines = 2;
                 
                 UILabel *nameL1 = [[UILabel alloc] initWithFrame:CGRectMake(10,gao + 45, 70, 45)];
                 nameL1.textColor = [ToolList getColor:@"7d7d7d"];
                 nameL1.font = [UIFont systemFontOfSize:13];
                 [self addSubview:nameL1];
                 
                 UILabel *content1 = [[UILabel alloc] initWithFrame:CGRectMake(70,gao + 45, __MainScreen_Width-70, 45)];
                 content1.textColor = [ToolList getColor:@"7d7d7d"];
                 content1.font = [UIFont systemFontOfSize:13];
                 [self addSubview:content1];
                 nameL1.numberOfLines = 1;
                 content1.numberOfLines = 2;
                 
                 UILabel *nameL2 = [[UILabel alloc] initWithFrame:CGRectMake(10,gao + 2*45, 70, 45)];
                 nameL2.textColor = [ToolList getColor:@"7d7d7d"];
                 nameL2.font = [UIFont systemFontOfSize:13];
                 [self addSubview:nameL2];
                 
                 UILabel *content2 = [[UILabel alloc] initWithFrame:CGRectMake(70,gao + 2*45, __MainScreen_Width-70, 45)];
                 content2.textColor = [ToolList getColor:@"7d7d7d"];
                 content2.font = [UIFont systemFontOfSize:13];
                 [self addSubview:content2];
             

                 nameL2.numberOfLines = 1;
                 content2.numberOfLines = 2;
              
                nameL.text = [NSString stringWithFormat:@"咨询产品%d:",i+1];
                content.text = [ToolList changeNull:[dic1 objectForKey:@"productCodeLabel"]];
                 
                 CGRect contentRect1 = [content.text  boundingRectWithSize:CGSizeMake(content.frame.size.width ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}context:nil];
                 content.frame = CGRectMake(content.frame.origin.x, gao, content.frame.size.width, contentRect1.size.height+10);
                 nameL.frame =CGRectMake(nameL.frame.origin.x, gao, nameL.frame.size.width, contentRect1.size.height+10);
                 
                 gao +=contentRect1.size.height+10;
                 
                        nameL1.text = @"预算:";
                         content1.text = [ToolList changeNull:[dic1 objectForKey:@"budget"]];
                 
                  CGRect contentRect2 = [content1.text  boundingRectWithSize:CGSizeMake(content1.frame.size.width ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}context:nil];
                 
                 content1.frame = CGRectMake(content1.frame.origin.x, gao, content1.frame.size.width, contentRect2.size.height+10);
                 nameL1.frame =CGRectMake(nameL1.frame.origin.x, gao, nameL1.frame.size.width, contentRect2.size.height+10);
                 
                 gao +=contentRect2.size.height+10;
                 
                        nameL2.text = @"交付周期:";
                         content2.text = [ToolList changeNull:[dic1 objectForKey:@"deliveryCycleLabel"]];
                 
                 CGRect contentRect3 = [content2.text  boundingRectWithSize:CGSizeMake(content2.frame.size.width ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}context:nil];
                 
                 content2.frame = CGRectMake(content2.frame.origin.x, gao, content2.frame.size.width, contentRect3.size.height+10);
                 nameL2.frame =CGRectMake(nameL2.frame.origin.x, gao, nameL2.frame.size.width, contentRect3.size.height+10);
                 
                 gao +=contentRect3.size.height+10;
                 
               

                }

                 }

        NSArray *arr = @[@"客户需求:",@"Q Q:",@"微 信:",@"主营业务:"];
              
          for (int j=0; j<arr.count; j++) {
              
              {
                  if (j==0 || j==1) {
                     gao += 10;
                      [self.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(10, gao ) toPoint:CGPointMake(__MainScreen_Width-40, gao ) andWeight:0.8 andColorString:@"E7E7EB"]];
                      gao += 10;
                  }
                  
                  UILabel *nameL1 = [[UILabel alloc] init];
                  nameL1.text = [arr objectAtIndex:j];
                  nameL1.textColor = [ToolList getColor:@"7d7d7d"];
                  nameL1.font = [UIFont systemFontOfSize:13];
                  [self addSubview:nameL1];
                  
                  UILabel *content1 = [[UILabel alloc] initWithFrame:CGRectMake(70, j*45, __MainScreen_Width-70, 45)];
                  content1.textColor = [ToolList getColor:@"7d7d7d"];
                  content1.font = [UIFont systemFontOfSize:13];
                  [self addSubview:content1];
                  nameL1.numberOfLines = 0;
                  content1.numberOfLines = 0;
                  
                  if (nameL1.text.length < 5 ) {
                      nameL1.frame = CGRectMake(10, gao, 45, 45);
                      content1.frame = CGRectMake(55, gao, __MainScreen_Width-55, 45);
                  }else{
                      nameL1.frame = CGRectMake(10, gao, 60, 45);
                      nameL1.numberOfLines = 0;
                      content1.frame = CGRectMake(70, gao, __MainScreen_Width-70, 45);
                  }
                  switch (j) {
                  
                      case 0:
                      {
                          content1.text = [ToolList changeNull:[dic objectForKey:@"custRequirement"]];
                          
                          break;
                      }
                      case 1:
                      {
                          content1.text = [ToolList changeNull:[dic objectForKey:@"qq"]];
                          
                          break;
                      }
                      case 2:
                      {
                          content1.text = [ToolList changeNull:[dic objectForKey:@"weChat"]];
                          
                          break;
                      }
                      case 3:
                      {
                          
                          content1.text = [ToolList changeNull:[dic objectForKey:@"mainBusiness"]];
                          break;
                      }
                    default:
                          break;
                  }
                  
                  
                  
                  CGRect contentRect1 = [content1.text  boundingRectWithSize:CGSizeMake(content1.frame.size.width ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}context:nil];
                  
                  content1.frame = CGRectMake(content1.frame.origin.x, gao, content1.frame.size.width, contentRect1.size.height+10);
                  nameL1.frame = CGRectMake(10, gao,  nameL1.frame.size.width, contentRect1.size.height+10);
                  
                  gao += contentRect1.size.height+10;
              }
          }
          
             }

//    if([[dic objectForKey:@"intentionalProductsList"] count])
//    {
//
//    self.frame = CGRectMake(0, 0, __MainScreen_Width, gao+45*3);
//    }
//    else
//    {
        self.frame = CGRectMake(0, 0, __MainScreen_Width, gao)   ;
//    }
     return self;
    
}
@end

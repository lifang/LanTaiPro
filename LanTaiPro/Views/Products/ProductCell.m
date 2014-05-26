//
//  ProductCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductCell.h"

#define ImageSize 100
#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation ProductCell

- (void)awakeFromNib
{
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView setImage:[[UIImage imageNamed:@"appoint-cell"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
    [self.contentView insertSubview:self.backgroundImageView atIndex:0];
    self.backgroundImageView.frame = (CGRect){0,0,568,122};
    self.numberImageView.hidden = YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier object:(id)object type:(NSInteger)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ProductCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    self.backgroundColor = [UIColor clearColor];
    self.objectModel = object;
    
    self.type = type;
    if (type==0 || type==1) {
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.objectModel;
        self.titlelabel.text = psModel.p_name;
        self.detailLabel.text = psModel.p_description;
        [self.headerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,psModel.p_imageUrl]] placeholderImage:[UIImage imageNamed:@"userAdd"]];
        self.statusButton.selected = [psModel.p_selected boolValue];
    }else {
        CardModel *cardModel = (CardModel *)self.objectModel;
        self.titlelabel.text = cardModel.c_name;
        self.detailLabel.text = cardModel.c_description;
        [self.headerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,cardModel.c_imageUrl]] placeholderImage:[UIImage imageNamed:@"userAdd"]];
        self.statusButton.selected = [cardModel.c_selected boolValue];
    }
    self.numberImageView.hidden = !self.statusButton.selected;
    
    return self;
}

-(void)setIdxPath:(NSIndexPath *)idxPath{
    _idxPath = idxPath;
    self.statusButton.tag = idxPath.row;
}
-(CGSize)returnSizeWithString:(NSString *)string
{
    UIFont *aFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
    CGSize size = [string sizeWithFont:aFont constrainedToSize:CGSizeMake(388, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    ///info
    NSString *detailString;
    if (self.type==0 || self.type==1) {
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.objectModel;
        detailString = psModel.p_description;
    }else {
        CardModel *cardModel = (CardModel *)self.objectModel;
        detailString = cardModel.c_description;
    }
    CGSize size = [self returnSizeWithString:detailString];
    if (size.height-70>0){
        self.detailLabel.frame = (CGRect){120,48,380,70};
    }else {
        self.detailLabel.frame = (CGRect){120,48,380,size.height};
    }
    [self.detailLabel layoutIfNeeded];
}
#pragma mark - 点击事件
-(IBAction)selectProduct:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.numberImageView.hidden = !btn.selected;
    [self.delegate selectedProduct:btn cell:self isSelected:btn.selected];
}

-(IBAction)coverBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.delegate expandWithButton:btn Cell:self];
}
@end

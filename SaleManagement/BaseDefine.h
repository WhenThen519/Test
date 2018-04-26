//
//  BaseDefine.h
//  SaleManagement
//
//  Created by feixiang on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#ifndef BaseDefine_h
#define BaseDefine_h
#pragma mark - 导入公共头文件位置
#import <AFNetworking.h>
#import "FX_UrlRequestTool.h"
#import "UIControl+UIControl_XY.h"
#import "ToolList.h"
#import "FX_Label.h"
#import "FX_Button.h"
#import "handView.h"
#import "sss.h"
#import "PullDownMenu.h"
#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"
#import "renWuViewController.h"
#pragma mark - 宏定义url位置
// host
static NSString *const Host_url=@"http://m.api.ceboss.cn/SmaMobile/";
//static NSString *const Host_url=@"http://10.12.40.11:8080/SmaMobile/";
//static NSString *const Host_url = @"http://10.12.40.11:6060/SmaMobile/";
//static NSString *const Host_url=@"http://bjm.api.ceboss.cn/SmaMobile/";

// 登录
//static NSString *const Login_url=@"security/smaLogin/init.action";
static NSString *const Login_url=@"security/mobile/login.action";
//登出
static NSString *const LoginOut_url=@"security/mobile/loginOut.action";
//修改密码
static NSString *const ChangePassword_url=@"security/mobile/changePassword.action";
//我知道了公告
static NSString *const signNotice_url=@"mobile/mobileNoticeAction/signNotice.action";

//提交绑定手机
static NSString *const bindingPhone_url=@"mobileCode/bindingPhone.action";

//

//发送验证码
static NSString *const getPhoneValidateCode_url=@"mobileCode/getPhoneValidateCode.action";

//总监首页
static NSString *const MobileMajordomoIndexAction_url=@"majordomo/mobile/action/MobileMajordomoIndexAction/init.action";

//IOS查询版本号
static NSString *const onCheckVersion_url=@"mobile/version/findVersion4IOS.action";
//
//商务代表首页
static NSString *const Business_url=@"saler/mobile/action/MobileSalerIndexAction/init.action";

// 商务---话术提示
static NSString *const SWspeechCraft_url = @"/saler/mobile/action/MobileCustResourceAction/speechCraft.action";

// 商务---沟通结果释放原因
static NSString *const SW_releaseCust_url = @"/operate/saler/releaseCust.action";

// 商务---收藏转保护(沟通结果中的保护按钮对应的请求)
static NSString *const SW_protectCustomer_url = @"/operate/saler/protectCustomer.action";

// 商务---沟通结果收藏(沟通结果中的收藏按钮对应的请求)
static NSString *const SW_collectionCustomer_url = @"/operate/saler/collectionCustomer.action";

// 商务---公海筛选项
static NSString *const SWfilterData_url = @"/saler/mobile/action/MobileCustResourceAction/filterData.action";

//扫名片后台统计
static NSString *const ScanCard_url=@"operate/saler/scanCard.action";
//区总首页
static NSString *const mobileAreaM_url=@"areaMajordomo/mobile/action/mobileAreaMajordomoIndexAction/init.action";

//商务经理首页
static NSString *const BusinessM_url = @"manager/mobile/action/MobileManagerIndexAction/init.action";
//写记录
static NSString *const CustVisitLog_url = @"mobile/custVisitLog/saveCustVisitLog.action";

//经理回访或陪访
static NSString *const saveCallBackLog_url = @"mobile/custVisitLog/saveCallBackLog.action";

//部门员工统计
static NSString *const EmployeeCountM_url = @"manager/mobile/action/MobileManagerIndexAction/employeeCount.action";
//部门客户统计
static NSString *const DeptCustM_url = @"manager/mobile/action/MobileManagerResourceAction/getDeptCust.action";
//经理流失客户数据查询
static NSString *const DepLostCust_url = @"manager/mobile/action/MobileManagerResourceAction/deptLostCust.action";
//总监流失客户数据查询
static NSString *const DepLostCustZJ_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/subLostCust.action";
//我司客户统计
static NSString *const SubCust_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/getSubCust.action";
//搜索
static NSString *const WillAssignCustByCustName_url = @"manager/mobile/action/MobileManagerResourceAction/getWillAssignCustByCustName.action";
//总监待分配搜索
static NSString *const WillAssignCustByCustName1_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/getWillAssignCustByCustName.action";
//商务--写记录--查询客户
static NSString *const SwCustM_url = @"saler/mobile/action/MobileCustResourceAction/searchMyCust.action";
//查询客户的联系人列表
static NSString *const LinkManNameList_url = @"mobile/custVisitLog/getLinkManNameList.action";
//经理--任务目标
static NSString *const addRenWu_url = @"/manager/mobile/action/MobileManagerResourceAction/GoalGetting.action";
//总监--任务目标
static NSString *const ZJRenWu_url = @"/majordomo/mobile/action/MobileMajordomoResourceAction/GoalGettingMajordomo.action";

//经理--任务目标确定按钮
static NSString *const baoCUNRenWu_url = @"/manager/mobile/action/MobileManagerResourceAction/GoalSetting.action";
//总监--任务目标确定按钮
static NSString *const ZJbaoCUNRenWu_url = @"/majordomo/mobile/action/MobileMajordomoResourceAction/GoalSettingMajordomo.action";
//经理待分配客户
static NSString *const AssignCustM_url = @"manager/mobile/action/MobileManagerResourceAction/getWillAssignCust.action";
//经理分配意向客户
static NSString *const IntentCust_url = @"operate/manager/getIntentCust.action";
//总监的待分配客户列表(总监的升迁客户列表)
static NSString *const WillAssignCust_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/getWillAssignCust.action";
//总监---平调
static NSString *const EmpTurnover_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/EmpTurnover.action";
//总监---平调操作
static NSString *const EmpTurnoverChoose_url = @"operate/majordomo/empTurnoverChoose.action";
//总监---分配意向客户
static NSString *const ZJassignIntentCust_url = @"operate/majordomo/assignIntentCust.action";
//总监---分配客户
static NSString *const ZJAssignCustToDept_url = @"operate/majordomo/assignCustToDept.action";
//调整客户
static NSString *const AdjustCustToSaler_url = @"operate/manager/adjustCustToSaler.action";

//总监----分配客户
static NSString *const ZJassignCustToDept_url = @"operate/majordomo/assignCustToDept.action";

//总监----更改部门
static NSString *const ZJadjustCustToDept_url = @"operate/majordomo/adjustCustToDept.action";

//分配客户
static NSString *const AssignCustToSaler_url = @"operate/manager/assignCustToSaler.action";
//经理意向客户列表及详情
static NSString *const IntentCustDept_url = @"manager/managerSjAction/willAssignSjList.action";

//总监---意向客户列表及详情
//static NSString *const ZJIntentCust2Majordomo_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/findIntentCust2Majordomo.action";
//总监分配商机到商务
static NSString *const assignSjToSaler_url = @"majordomo/majordomoSjAction/assignSjToSaler.action";
//经理分配商机到商务
static NSString *const assignSjToSaler_url_jl = @"manager/managerSjAction/assignSjToSaler.action";
//总监分配商机到bumen
static NSString *const assignSjToDept_url = @"majordomo/majordomoSjAction/assignSjToDept.action";
static NSString *const ZJIntentCust2Majordomo_url = @"/majordomo/majordomoSjAction/willAssignSjList.action";
static NSString *const giveUpSjIntentCust_url = @"operate/saler/giveUpSjIntentCust.action";
//经理意向客户释放理由查询
static NSString *const ReleseCustReason_url = @"manager/mobile/action/mobileManagerIntentCustAction/getReleseCustReason.action";

//经理意向客户释放理由查询
static NSString *const protectSjIntentCust = @"operate/saler/protectSjIntentCust.action";

//经理释放客户
static NSString *const ReleaseCust_url = @"operate/manager/releaseCust.action";
//总监释放客户
static NSString *const ZJReleaseCust_url = @"operate/majordomo/releaseCust.action";
//商务--收藏转保护
static NSString *const protectCustomer_url = @"operate/saler/protectCustomer.action";

//商务--意向保护
static NSString *const protectIntentCustAndExist_url = @"operate/saler/protectIntentCustAndExist.action";
//

//重点跟进和方案报价
static NSString *const workAccountCustDetail_url = @"saler/mobile/action/MobileSalerCountAction/workAccountCustDetail.action";


//经理--重点跟进和方案报价
static NSString *const jlworkAccountCustDetail_url = @"manager/mobile/action/MobileManagerResourceAction/workAccountCustDetail.action";

//总监--重点跟进和方案报价
static NSString *const zjworkAccountCustDetail_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/workAccountCustDetail.action";

//商务--变更客户状态
static NSString *const changeCustState_url = @"operate/saler/changeCustState.action";

//商务--释放客户
static NSString *const swreleaseCust_url = @"operate/saler/releaseCust.action";
//请求所有商务 含全部
static NSString *const SalerAndAll_url = @"manager/mobile/action/MobileManagerResourceAction/getSalerAndAll.action";

//调整
static NSString *const SalerProtectCount_url = @"manager/mobile/action/MobileManagerResourceAction/findSalerProtectCount.action";
//分配
static NSString *const SalerCount_url = @"manager/mobile/action/MobileManagerResourceAction/findSalerCount.action";
//查询部门商务代表净现金到账列表
static NSString *const DeptYeji_url = @"manager/mobile/action/MobileManagerResourceAction/getDeptYeji.action";

//总监----部门和商务获取
static NSString *const deptListInit_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/deptListInitBySjIntent.action";


//总监净现金到账列表
static NSString *const SubYeji_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/getSubYeji.action";

//公海接口
static NSString *const MobileManagerResourceAction_url = @"manager/mobile/action/MobileManagerResourceAction/list.action";

//总监---公海接口
static NSString *const zjgonghaiList_url = @"saler/mobile/action/MobileCustResourceAction/salerPublicData.action";
//商机分配
static NSString *const getWillAssignCust_url = @"manager/mobile/action/MobileManagerResourceAction/getWillAssignCust.action";
//总监商机分配列表
static NSString *const getWillAssignCust_url_ZJ = @"/majordomo/mobile/action/MobileMajordomoIndexAction/getWillAssignCust.action";

//收藏夹salerPublicData
static NSString *const salerCollectionCust_url = @"saler/mobile/action/MobileCustResourceAction/salerCollectionCust.action";

//模糊搜索--1.收藏夹 2.我的客户（保护库，签约库，流失客户，共享客户）3.部门客户 4.分司客户
static NSString *const vagueSearch_url = @"saler/mobile/action/MobileCustResourceAction/vagueSearch.action";


//收藏夹详情
static NSString *const custDetail_url = @"saler/mobile/action/MobileCustResourceAction/custDetail.action";
//yixiangkehuxiangqing
static NSString *const intentCustDetail_url = @"saler/mobile/action/mobileSalerIntentCustAction/intentCustDetail.action";

//收藏夹详情2
static NSString *const custDetailList = @"saler/mobile/action/MobileCustResourceAction/custDetailList.action";

//公海模糊搜索接口
static NSString *const CustomerBySolr_url = @"mobile/custVisitLog/findCustomerBySolr.action";
//公海筛选接口
static NSString *const OpenSelect_url = @"saler/mobile/action/MobileSearchTagAction/getSearchTag.action";
//公海推荐/取消推荐
static NSString *const Recommend_url = @"operate/manager/recommend.action";
//查询某个商务的当月到账详情
static NSString *const DeptYejiDetail_url = @"manager/mobile/action/MobileManagerResourceAction/getDeptYejiDetail.action";

//总监查询部门当月到账详情
static NSString *const ZJDeptYejiDetail_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/getSubYejiDetail.action";

//经理拜访统计majordomo/mobile/action/MobileMajordomoResourceAction/workAccount4SubNew.action
static NSString *const workAccount4DeptNew_url = @"manager/mobile/action/MobileManagerResourceAction/workAccount4DeptNew.action";
//总监拜访统计
static NSString *const workAccount4SubNew_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/workAccount4SubNew.action";
//生产中客户
static NSString *const InProductionCust_url = @"manager/mobile/action/MobileManagerResourceAction/findInProductionCust.action";

//总监---生产中客户列表查询
static NSString *const ZJfindInProductionCust_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/findInProductionCust.action";

//总监---.生产中客户详情查询
static NSString *const ZJfindInProductionCustDetail_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/findInProductionCustDetail.action";


//生产中的客户-查询生产进度
static NSString *const InProductCustDetail_url = @"saler/mobile/action/MobileSalerCountAction/getInProductCustDetail.action";
//经理释放意向客户
static NSString *const releaseIntentCust_url = @"manager/managerSjAction/releaseSj.action";
//总监释放意向客户
static NSString *const zjReleaseIntentCust_url = @"majordomo/majordomoSjAction/releaseSj.action";

//商务释放意向客户
static NSString *const swreleaseIntentCust_url = @"operate/saler/giveUpSjIntentCust.action";
//总监产品到期客户
static NSString *const ZJDueProducts_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/getDueProducts.action";
//产品到期客户
static NSString *const DueProducts_url = @"manager/mobile/action/MobileManagerResourceAction/getDueProducts.action";
//CEO个人积分
static NSString *const empIntegralRank_url = @"mobile/mobileCeOneRankAction/empIntegralRank.action";
//CEO部门积分
static NSString *const deptIntegralRank_url = @"mobile/mobileCeOneRankAction/deptIntegralRank.action";
//CEO筛选项
static NSString *const getFilter_url = @"mobile/mobileCeOneRankAction/getFilter.action";
//获取本部门的所有商务
static NSString *const GetSalers_url = @"manager/mobile/action/MobileManagerResourceAction/getSalers.action";

//总监---获取所有部门
static NSString *const ZJdeptInit_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/deptInit.action";
//总监---获取所有部门
static NSString *const SubByAreaId_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getSubByAreaId.action";
//区总---获取分司和部门
static NSString *const QZdeptInit_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/getSubAndDeptByAreaId.action";

//区总----分司和部门（带上不限字段）
static NSString *const qz_getSubAndDeptByAreaIdNew_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getSubAndDeptByAreaIdNew.action";

//获得所有的产品列表
static NSString *const ProductListInit_url = @"manager/mobile/action/MobileManagerResourceAction/productListInit.action";
//欠款客户列表
static NSString *const ArrearCust_url = @"manager/mobile/action/MobileManagerResourceAction/findArrearCust.action";
//总监欠款客户列表
static NSString *const ZJArrearCust_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/findArrearCust.action";
//总监欠款客户详情查询
static NSString *const ZJArrearCustDetail_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/findArrearCustDetail.action";
//经理根据传入日期，查询一周的带有日程的日期和当日的日程
static NSString *const ScheduleByDate4Dept_url = @"mobile/schedule/getScheduleByDate4Dept.action";

//根据传入日期，查询当月的所有有日程安排的日期和当日的
static NSString *const ScheduleByDate_url = @"mobile/schedule/getScheduleByDate.action";
//总监根据传入日期，查询一周的带有日程的日期和各部门的
static NSString *const ScheduleByDate4Sub_url = @"mobile/schedule/getScheduleByDate4Sub.action";
//总监根据传入日期和传入ID,查询该部门该天的日程
static NSString *const Schedule4Sub_url = @"mobile/schedule/getSchedule4Sub.action";
//添加日程
static NSString *const addSchedule_url = @"mobile/schedule/saveSchedule.action";
//删除日程
static NSString *const deleteSchedule_url = @"mobile/schedule/deleteSchedule.action";
//编辑日程
static NSString *const updateSchedule_url = @"mobile/schedule/updateSchedule.action";
//商务——公海列表查询
static NSString *const sea_url=@"saler/mobile/action/MobileCustResourceAction/findCustResource.action";
//商务——收藏客户/保护客户
static NSString *const getCust_url=@"operate/saler/getCust.action";
//商务——地区查询
static NSString *const seaAdd_url=@"saler/mobile/action/MobileSearchTagAction/getSearchTag.action";
//商务--即将释放客户
static NSString *const release_url = @"saler/mobile/action/MobileSalerCountAction/getGonnaReleaseCust.action";
//商务--生产中的客户-查询生产进度
static NSString *const achedule_url = @"saler/mobile/action/MobileSalerCountAction/getInProductCustDetail.action";
//商务--生产中的客户
static NSString *const producing_url = @"saler/mobile/action/MobileSalerCountAction/getInProductCust.action";
//商务--欠款客户
static NSString *const debt_url = @"saler/mobile/action/MobileSalerCountAction/getDebitCust.action";
//商务--到期产品客户统计详情
static NSString *const getDue_url = @"saler/mobile/action/MobileSalerCountAction/getDueProductsCust.action";
//商务--客户定位
static NSString *const orientation_url = @"saler/mobile/action/MobileCustResourceAction/searchCust.action";
//商务--我的客户
static NSString *const myClient_url = @"saler/mobile/action/MobileCustResourceAction/getMyCustResource.action";

//商务--我的客户--流失客户
static NSString *const salerLostCust_url = @"saler/mobile/action/MobileCustResourceAction/salerLostCust.action";

//商务--添加客户---行业大列表查询
static NSString *const industry_url = @"saler/mobile/action/addCustMobile/getIndustry.action";
//商务--添加联系人---查询联系人职位列表
static NSString *const position_url = @"saler/mobile/action/MobileCustResourceAction/getPosition.action";

//商务--添加联系人---查询公司性质列表
static NSString *const getCustNature_url = @"saler/mobile/action/addCustMobile/getCustNature.action";

//商务--添加客户--公司-验证
static NSString *const checkCust_url = @"saler/mobile/action/addCustMobile/checkCust.action";

//扫名片添加客户--公司-验证
static NSString *const checkCustScan_url = @"saler/mobile/action/addCustMobile/checkCustScan.action";
//商务--添加客户---公司--相似客户
static NSString *const similarCust_url = @"saler/mobile/action/addCustMobile/similarCustGet.action";
//商务--添加客户--个人-验证
static NSString *const checkCertificateNo_url = @"saler/mobile/action/addCustMobile/checkCertificateNo.action";
//商务--意向客户列表查询
//static NSString *const getIntentCustSaler_url = @"saler/mobile/action/mobileSalerIntentCustAction/getIntentCustSaler.action";

//商务--意向客户列表查询
static NSString *const getIntentCustSaler_url = @"saler/mobile/action/mobileSalerIntentCustAction/salerIntentCust.action";

//商务--添加客户---个人--相似客户
static NSString *const personalSimilarCustGet_url = @"saler/mobile/action/addCustMobile/personalSimilarCustGet.action";
//商务--沟通记录
static NSString *const record_url = @"saler/mobile/action/MobileSalerCountAction/workAccountVisitDetail.action";
//客户信息经理-提示和操作
static NSString *const CustTip_url = @"mobile/MobileCustomerDetailAction/getCustTip.action";
//客户信息-沟通记录
static NSString *const custId_url = @"mobile/MobileCustomerDetailAction/getCmCustVisitLogByCustId.action";
//客户详情产品列表
static NSString *const CustBuyProduct_url = @"mobile/MobileCustomerDetailAction/getCustBuyProduct.action";
//客户信息-客户详情
static NSString *const CustDetail_url = @"mobile/MobileCustomerDetailAction/getCustDetail.action";
//客户信息-联系人
static NSString *const linkMan_url = @"mobile/MobileCustomerDetailAction/getLinkMan.action";
//商务总监的沟通记录查询
static NSString *const findCustVisitLog2Majordomo_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/workAccountVisitDetail.action";
//商务经理的沟通记录查询
static NSString *const manager_url = @"manager/mobile/action/MobileManagerResourceAction/workAccountVisitDetail.action";
//商务--提交评论或回复
static NSString *const toreply_url = @"mobile/custVisitLog/saveVisitLogsReply.action";
//商务--评论或回复的展示
static NSString *const reply_url = @"mobile/custVisitLog/findVisitLogsReply.action";
//商务--沟通记录---点赞或取消赞
static NSString *const zan_url = @"mobile/custVisitLog/saveVisitLogsPraise.action";
//商务--查询沟通记录点赞列表
static NSString *const praise_url = @"mobile/custVisitLog/getVisitLogsPraise.action";
//客户信息-合同列表查询
static NSString *const byCustId_url = @"mobile/MobileCustomerDetailAction/getContractByCustId.action";
//客户信息-合同列表-合同详情
static NSString *const detail_url = @"mobile/MobileCustomerDetailAction/getContractDetail.action";
//净现金到账明细
static NSString *const accountDetail_url = @"saler/mobile/action/MobileSalerCountAction/getAccountDetail.action";

//商务--工作统计
static NSString *const swworkAccount_url = @"saler/mobile/action/MobileSalerCountAction/workAccountNew.action";

//经理--工作统计
static NSString *const jlworkAccount_url = @"manager/mobile/action/MobileManagerResourceAction/workAccount4Dept.action";

//总监--工作统计
static NSString *const zjworkAccount_url = @"majordomo/mobile/action/MobileMajordomoResourceAction/workAccount4Sub.action";

//.商务代表--保护意向客户
static NSString *const swprotectIntentCust_url = @"operate/saler/protectIntentCust.action";

//.商务代表--添加客户保存操作
static NSString *const swaddCust_url = @"operate/saler/addCust.action";

//
//常用联系人列表查询+详情数据展示
static NSString *const getFrequentContacts_url = @"saler/mobile/action/MobileCustResourceAction/getFrequentContacts.action";

//商务--常用联系人搜索
static NSString *const searchFrequentContacts_url = @"saler/mobile/action/MobileCustResourceAction/searchFrequentContacts.action";

//商务--取消常用联系人
static NSString *const deleteFrequentContact_url = @"operate/saler/deleteFrequentContact.action";

//商务--从客户详情页将现有的联系人保存为常用联系人
static NSString *const convertContact_url = @"operate/saler/convertContact.action";

//商务--保存联系人
static NSString *const addContact_url = @"operate/saler/addContact.action";

//总监--排行榜首页
static NSString *const ZJpaihangbang_url = @"/mobile/mobileRankAction/getIndex4Majordomo.action";
//经理--排行榜首页
static NSString *const JLpaihangbang_url = @"/mobile/mobileRankAction/getIndex4Manager.action";
//商务--排行榜首页
static NSString *const SWpaihangbang_url = @"/mobile/mobileRankAction/getIndex4Saler.action";

//区总--排行榜首页
static NSString *const QZpaihangbang_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/getIndex4AreaMajordomo.action";


//扫描名片--保存客户接口
static NSString *const ContactScan_url = @"operate/saler/addContactScan.action";

//个人榜单
static NSString *const CountryPersonal_url = @"mobile/mobileRankAction/getCountryPersonal.action";
//区总----分司榜单中个人栏接口
static NSString *const PersonalSubRankSaler_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getSubRankSaler.action";
//区总----分司榜单中部门栏接口
static NSString *const DeptSubRank_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getSubRankDept.action";
//区总净现金到账统计页面--统计
static NSString *const QZgetAreaYeJi_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getAreaYeJi.action";

//区总净现金到账统计页面--明细
static NSString *const MXgetAreaYeJi_url = @"areaMajordomo/mobile/action/mobileAreaResourceAction/getAreaYeJiDetail.action";
//
//分司-部门榜单
static NSString *const SubRankDept_url = @"mobile/mobileRankAction/getSubRankDept.action";

//部门榜单
static NSString *const CountryDept_url = @"mobile/mobileRankAction/getCountryDept.action";

//.区域-部门排行榜
static NSString *const AreaDept_url = @"mobile/mobileRankAction/getAreaDept.action";


//分司榜单
static NSString *const CountrySub_url = @"mobile/mobileRankAction/getCountrySub.action";

//区域-分司排行榜
static NSString *const AreaSub_url = @"mobile/mobileRankAction/getAreaSub.action";

//区域榜单
static NSString *const CountryArea_url = @"mobile/mobileRankAction/getCountryArea.action";

//部门内榜单
static NSString *const BuMenNArea_url = @"mobile/mobileRankAction/getDeptData.action";
// 区总  部门内榜单
static NSString *const QZBuMenNArea_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/getDeptData.action";

//总监任务完成比
static NSString *const ZJWanChengBi_url = @"mobile/mobileRankAction/getSub.action";

//区总--客户定位
static NSString *const QZorientation_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/searchCust.action";
//区总--市场查询
static NSString *const QZshichangtation_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/getMarkets.action";

//区总--根据分公司查询市场
static NSString *const getMarketsBySubId_url = @"/areaMajordomo/mobile/action/mobileAreaResourceAction/getMarketsBySubId.action";

//区总--调整市场
static NSString *const QZtiaozhengtation_url = @"/operate/areaMajordomo/adjustCustMarket.action";

//总监培育库列表
static NSString *const peiYuKuCustDept_url = @"/majordomo/mobile/action/MobileMajordomoResourceAction/getIntentBreedCust.action";

//新增联系方式
static NSString *const AddContactInfo_url = @"/operate/saler/addContactInfo.action";
//查联系人详情所有数据

static NSString *const getLinkManDetail_url = @"/mobile/MobileCustomerDetailAction/getLinkManDetail.action";

//新增联系方式
static NSString *const ZJ_sou_url = @"/majordomo/mobile/action/MobileMajordomoIndexAction/getWillAssignCustByCustName.action";
//查联系人详情所有数据

static NSString *const jl_sou_url = @"/manager/mobile/action/MobileManagerResourceAction/getWillAssignCustByCustName.action";


// 收藏夹批量操作
static NSString *const protectAndRelease_url = @"/operate/saler/protectAndRelease.action";

//拜访记录点击
static NSString *const workAccountDetail_url = @"/saler/mobile/action/MobileSalerCountAction/workAccountDetail.action";

//陪访人选择列表
static NSString *const deptList_url = @"/mobile/custVisitLog/accompanySalerList.action";

//陪访人选择列表
static NSString *const accompanySalerSearch_url = @"/mobile/custVisitLog/accompanySalerSearch.action";

//写拜访记录-选择客户名称-客户搜索
static NSString *const searchCustForVisit_url = @"mobile/custVisitLog/searchCustForVisit.action";

//写拜访记录-选择客户名称-客户搜索-收藏客户/保护客户
static NSString *const getOneCust_url = @"operate/saler/getOneCust.action";

//公海专属市场和共享市场筛选项请求
static NSString *const getMarket_url = @"saler/mobile/action/MobileCustResourceAction/getMarket.action";

//公海搜索
static NSString *const salerPublicDataSearch_url = @"saler/mobile/action/MobileCustResourceAction/salerPublicDataSearch.action";

//总监待分配来源筛选
static NSString *const getFilterData_url = @"majordomo/mobile/action/MobileMajordomoIndexAction/getFilterData.action";

//经理待分配来源筛选
static NSString *const getWillAssignCust_url_2 = @"manager/mobile/action/MobileManagerResourceAction/getFilterData.action";

#pragma mark - 宏定义方法或者实例
#define SelectViewHeight1 35

#define SelectViewHeight 45
#define CaozuoViewHeight 45
#define FX_UrlRequestManager  [FX_UrlRequestTool shareUrlRequestTool]
//设备屏幕大小
#define __MainScreenFrame [[UIScreen mainScreen]bounds]
// 设备屏幕的宽
#define __MainScreen_Width  __MainScreenFrame.size.width
// 设备屏幕的高
#define __MainScreen_Height __MainScreenFrame.size.height
//判断手机的版本
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
//单行标题label的高度
#define OneLineTitleLabelHeight 30
//单行内容label的高度
#define OneLineContentLabelHeight 35
#define iphone_stateBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define IOS7_StaticHeight (IOS7? iphone_stateBar:0)

#define IOS7_Height (IOS7? 44+iphone_stateBar:44)
#define layer_Height 44
#define TabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?94:60) // 适配iPhone x 底栏高度_tabBarView.frame = CGRectMake(0, CurrentScreenHeight - TabbarHeight, CurrentScreenWidth, TabbarHeight);
#define barHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#pragma mark -
#endif /* BaseDefine_h */



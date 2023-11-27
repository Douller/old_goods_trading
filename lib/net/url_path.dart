class UrlPath {
  ///首页商品列表
  static const String homeGoodsList = 'index/index';

  ///热门搜索
  static const String hotSearchWords = 'index/keywords';

  ///商品分类
  static const String goodsCategory = 'goods/category';

  ///搜索配置
  static const String goodsSearchConfig = 'goods/searchConfig';

  ///商品搜索列表
  static const String goodsSearchList = 'goods/list';

  ///商品详情
  static const String goodsInfo = 'goods/info';

  ///关注和收藏
  static const String collectAndAdd = 'collect/add';

  ///取消关注和收藏
  static const String collectDel = 'collect/del';

  ///提交订单前的信息
  static const String orderBuyConfirm = 'orderBuy/confirm';

  ///支付
  // static const String orderPay = 'pay/pay';

  ///获取用户信息
  static const String userInfo = 'user/info';

  ///我的首页
  static const String userIndex = 'user/index';

  ///用户地址
  static const String userAddress = 'consignee/list';

  ///新增用户地址
  static const String addAddress = 'consignee/add';

  ///设置默认地址
  static const String setDefaultAddAddress = 'consignee/setDefault';

  ///删除用户地址
  static const String deleteAddress = 'consignee/del';

  ///获取所有地区
  static const String allArea = 'area/allList';

  ///获取国家
  static const String areaCountry = 'area/country';

  ///根据国家获取城市
  static const String areaList = 'area/list';

  ///获取发布信息分类
  static const String publishInfo = 'publish/info';

  ///我卖的
  static const String supplierOrders = 'supplier/orders';

  ///我发布的
  static const String supplierGoods = 'supplier/goods';

  ///创建订单
  static const String orderCreate = 'orderBuy/create';

  ///我的收藏
  static const String collectList = 'collect/goods';

  ///我的订单列表
  static const String orderList = 'order/list';

  ///上传图片
  static const String uploadImg = 'system/uploadImg';

  ///发布商品
  static const String publishCreate = 'publish/create';

  ///修改用户信息
  static const String userEdit = 'user/edit';

  ///优惠券
  static const String couponList = 'coupon/list';

  ///消息分类
  static const String messageCategory = 'message/category';

  ///消息列表
  static const String messageList = 'message/list';

  ///我的订单详情
  static const String myOrderDetails = 'order/view';

  ///取消我的订单
  static const String orderCancel = 'order/cancel';

  ///取消订单选项
  static const String cancelReason = 'order/cancelReason?r_type=2';

  ///下架商品
  static const String publishOffSale = 'publish/offsale?r_type=2';

  ///重新上架商品
  static const String publishOnSale = 'publish/onsale?r_type=2';

  ///登录
  static const String login = 'login/login';

  ///发布分类
  static const String publishCategory = 'goods/category';

  ///更多分类
  static const String morePublishBrands = 'publish/brands';

  ///更多品牌
  static const String morePublishCategorys = 'publish/categorys';

  ///足迹接口
  static const String collectHistory = 'collect/history';

  ///删除足迹接口
  static const String deletedHistory = 'collect/historydel';

  ///我的订单tarBar title
  static const String myOrderStatus = 'order/status';

  ///我卖的tarBar title
  static const String supplierOrderStatus = 'supplier/orderStatus';

  ///消息已读
  static const String messageRead = 'message/read';

  ///卖家商品详情
  static const String supplierOrderInfo = 'supplier/orderInfo';

  ///买家发表评论
  static const String commentAdd = 'comment/add';

  ///客服和关于我们
  static const String articleAbout = 'article/about';

  ///售后申请列表
  static const String orderAfterList = 'orderAfter/list';

  ///售后处理中列表
  static const String orderAfterProcessing = 'orderAfter/Processing';

  ///售后申请记录
  static const String orderAfterHistory = 'orderAfter/history';

  ///售后原因和类型
  static const String orderAfterRefundReason = 'orderAfter/refundReason';

  ///提交售后
  static const String orderAfterCreate = 'orderAfter/create';

  ///卖家售后
  static const String supplierAfterOrder = 'supplier/afterOrder';

  ///卖家主页
  static const String supplierInfo = 'supplier/info';

  ///卖家评价选项
  static const String supplierCommentList = 'supplier/commentList';

  ///卖家评价买家
  static const String commentSupplierAdd = 'comment/supplierAdd';

  ///买家售后详情
  static const String orderAfterView = 'orderAfter/view';

  ///卖家售后详情
  static const String supplierAfterOrderView = 'supplier/afterOrderView';

  ///会话页面添加商品信息
  static const String messageAddRalation = 'message/addRalation';

  ///会话页面获取商品信息
  static const String messageGetRalation = 'message/getRalation';

  ///版本更新
  static const String version = 'system/version';

  ///用户收入记录
  static const String revenueRecords = 'userMoneyLog/list';

  ///用户提现记录
  static const String withdrawRecords = 'withdraw/list';

  ///提现
  static const String withdraw = 'withdraw/create';

  ///添加银行卡
  static const String addBankCard = 'userBank/create';

  ///获取用户的银行卡列表
  static const String userBankList = 'userBank/list';

  ///获取可使用的银行列表
  static const String banksList = 'userBank/banks';

  ///获取用户提现余额
  static const String getWithdrawAmount = 'withdraw/index';

  ///获取附近的商品
  static const String nearby = 'index/nearby';

  ///买家物流信息
  static const String orderDeliveryInfo = 'order/deliveryInfo';

  ///卖家物流信息
  static const String afterOrderDeliveryInfo = 'afterOrder/deliveryInfo';

  ///获取附近位置信息
  static const String areaGetListByLonlat = 'area/getListByLonlat';

  ///获取快递公司
  static const String getKuaidi = 'order/kuaidi';

  ///发货
  static const String supplierDelivery = 'supplier/delivery';

  ///注销
  static const String userDel = 'user/del';

  static const String couponAdd = 'coupon/add';

  static const String publishShipPrice = 'publish/shipprice';

  static const String creatYuansfer = 'user/creatYuansfer';

  //获取手机验证码
  static const String sendPhoneCode = 'user/sendPhoneCode';

  //获取手机验证码
  static const String sendEmailCode = 'user/sendEmailCode';

  //获取手机号码地区
  static const String userPrefix = 'user/prefix';

  //验证短信是否正确
  static const String verifyPhoneCode = 'user/verifyCode';

  //验证邮箱
  static const String verifyEmailCode = 'user/verifyEmailCode';

  //更换手机号码
  static const String editMobile = 'user/editPhone';

  //更换邮箱
  static const String editEmail = 'user/editEmail';

  //修改密码
  static const String editPassword = 'user/editPassword';

  //绑定邮箱
  static const String bindEmail = 'user/bindEmail';

  //绑定手机号
  static const String bindPhone = 'user/bindPhone';

  //支付银行列表
  static const String paymentList = 'userBank/paymentList';

  //支付参数
  static const String payConfig = 'pay/payconfig';

  //验证微信支付宝
  static const String wxAlipay = 'micropay/v3/prepay';

  //验证银行卡或者PayPal
  static const String cardPaypal = "online/v4/secure-pay";
}

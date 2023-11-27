package com.douller.app


import  android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.Nullable
import cn.authing.guard.Authing
import cn.authing.guard.flow.AuthFlow
import com.douller.app.model.MicroPayRequest
import com.google.gson.Gson
import com.yuansfer.pay.YSAppPay
import com.yuansfer.pay.aliwx.AliWxPayMgr
import com.yuansfer.pay.aliwx.WxPayItem
import com.yuansfer.pay.api.OnResponseListener
import com.yuansfer.pay.util.ErrStatus
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject


class MainActivity : FlutterActivity(), AliWxPayMgr.IAliWxPayCallback {
    private lateinit var myResult: MethodChannel.Result
//    var pay: IAliWxPay = YSAppPay.getAliWxPay()
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        YSAppPay.getAliWxPay().registerAliWxPayCallback(this)
        YSAppPay.setLogEnable(true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val authingChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "Authing")


        authingChannel.setMethodCallHandler { call, result -> // 来自dart的方法调用。
            when (call.method) {
                "login" -> {
                    AuthFlow.start(this)
                    myResult = result
                }
            }
        }

        val payChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pay_plugin_channel")

        payChannel.setMethodCallHandler { call, _ ->
            when (call.method) {

                "weChat_pay" -> {
                    //微信支付
                    var amount: String? = call.argument("amount")

                    val wxRequest = MicroPayRequest()
                    wxRequest.token = call.argument("token")
                    wxRequest.merchantNo = call.argument("merchantNo")
                    wxRequest.storeNo = call.argument("storeNo")
                    wxRequest.vendor = "wechatpay"
                    if (amount != null) {
                        wxRequest.amount = amount.toDouble()
                    }
                    wxRequest.ipnUrl = call.argument("ipnUrl")
                    wxRequest.description = call.argument("description")
                    wxRequest.note = call.argument("note")
                    wxRequest.reference = call.argument("orderSN")
                    YSAppPay.getClientAPI().apiPost("/micropay/v3/prepay",
                        Gson().toJson(wxRequest),
                        object : OnResponseListener<String?> {
                            override fun onSuccess(s: String?) {
                                try {
                                    val dataObj = JSONObject(s)
                                    if (dataObj.has("result")) {
                                        val resultObj = dataObj.getJSONObject("result")
                                        YSAppPay.getAliWxPay().registerWXAPP(
                                            applicationContext, resultObj.getString("appid")
                                        )
                                        val wxPayItem = WxPayItem()
                                        wxPayItem.appId = resultObj.getString("appid")
                                        wxPayItem.packageValue = resultObj.getString("package")
                                        wxPayItem.prepayId = resultObj.getString("prepayid")
                                        wxPayItem.partnerId = resultObj.getString("partnerid")
                                        wxPayItem.nonceStr = resultObj.getString("noncestr")
                                        wxPayItem.sign = resultObj.getString("sign")
                                        wxPayItem.timestamp = resultObj.getString("timestamp")
                                        YSAppPay.getAliWxPay().requestWechatPayment(wxPayItem)
                                    }
                                } catch (e: JSONException) {
//                                    mLogger.log(e.message)
                                }
                            }

                            override fun onFail(e: java.lang.Exception) {
//                                mLogger.log(e.localizedMessage)
                            }
                        })
                }
                "alipay_pay" -> {
                    Log.d("tag","==============================支付宝支付")
                    //支付宝支付
                    var amount: String? = call.argument("amount")
                    val info = MicroPayRequest()
                    info.token = call.argument("token")
                    info.merchantNo = call.argument("merchantNo")
                    info.storeNo = call.argument("storeNo")
                    info.vendor = "alipay"
                    if (amount != null) {
                        info.amount = amount.toDouble()
                    }
                    info.ipnUrl = call.argument("ipnUrl")
                    info.description = call.argument("description")
                    info.note = call.argument("note")
                    info.reference = call.argument("orderSN")
                    YSAppPay.getClientAPI().apiPost("/micropay/v3/prepay",
                        Gson().toJson(info),
                        object : OnResponseListener<String?> {
                            override fun onSuccess(s: String?) {
                                try {
                                    val dataObj = JSONObject(s)
                                    if (dataObj.has("result")) {
                                        val resultObj = dataObj.getJSONObject("result")
                                        YSAppPay.getAliWxPay().requestAliPayment(
                                            this@MainActivity, resultObj.getString("payInfo")
                                        )
                                    }
                                } catch (e: JSONException) {
//
                                }
                            }

                            override fun onFail(e: Exception) {
//                                mLogger.log(e.localizedMessage)
                            }
                        })

                }
                "payPal_pay" -> {
                    //payPal支付
                }
                "card_pay" -> {
                    //卡支付
                }

            }
        }
    }





    //Authing
    override fun onActivityResult(requestCode: Int, resultCode: Int, @Nullable data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1024 && resultCode == 42 && data != null) {

            val userInfo = Authing.getCurrentUser()
            val gson = Gson()
            var userInfoStr = gson.toJson(userInfo)
            Log.d("tag", "==========================userInfoStr:$userInfoStr")
            myResult.success(userInfoStr)
        }
    }

    override fun onPaySuccess(payType: Int) {
        TODO("Not yet implemented")
    }

    override fun onPayFail(payType: Int, errStatus: ErrStatus?) {
        TODO("Not yet implemented")
    }

    override fun onPayCancel(payType: Int) {
        TODO("Not yet implemented")
    }

    override fun onDestroy() {
        super.onDestroy()
        YSAppPay.getAliWxPay().unregisterAliWxPayCallback(this)
    }
}

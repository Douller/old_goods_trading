package com.douller.app

import android.app.Application
import cn.authing.guard.Authing

class MyApp :Application(){
    override fun onCreate() {
        super.onCreate()
        Authing.setIsOverseas()
        Authing.init(this, "63e48a630a821b6ef2e93b24")
    }
}
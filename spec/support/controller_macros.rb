﻿# -*- coding:utf-8 -*-
module ControllerMacros
  def login_user
    before(:each) do
      controller.stub(:authenticate_user!).and_return true
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end
end
# -*- coding:utf-8 -*-
require 'spec_helper'

describe UsersController do
  describe "#after_sign_out_path_for" do
    login_user
    subject { get :destroy }
    it { should be_redirect }
    it { should redirect_to(new_user_session_url) }
  end
end

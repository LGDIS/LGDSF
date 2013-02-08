# -*- coding:utf-8 -*-
require 'spec_helper'

describe UsersController do
  # Deviseログイン認証
  login_user

  describe "#after_sign_out_path_for" do
    subject { get :destroy }
    it { should be_redirect }
    it { should redirect_to(new_user_session_url) }
  end
end

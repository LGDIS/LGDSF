# -*- coding:utf-8 -*-
require 'spec_helper'

describe Agent do

  context '正常の場合' do

    before do
      @agent = Agent.new
      @agent.name = "name"
      @agent.mail_address = "mail_address"
    end

    describe '@agent' do
      it 'DB登録が成功すること' do
        @agent.save.should be_true
      end
    end

    describe '@agent.name' do
      context 'nameが64文字以内の場合' do
        it 'DB登録が成功すること' do
          @agent.name = "a" * 64
          @agent.save.should be_true
        end
      end
    end

    describe '@agent.mail_address' do
      context 'mail_addressが256文字以内の場合' do
        it 'DB登録が成功すること' do
          @agent.mail_address = "m" * 256
          @agent.save.should be_true
        end
      end
    end

  end

  context '異常の場合' do

    before do
      @agent = Agent.new
      @agent.name = "name"
      @agent.mail_address = "mail_address"
    end

    describe '@agent.name' do
      context 'nameが65文字以上の場合' do
        it 'DB登録が失敗すること' do
          @agent.name = "a" * 65
          @agent.save.should be_false
        end
      end
    end

    describe "@agent.mail_address" do
      context 'mail_addressが257文字以上の場合' do
        it 'DB登録が失敗すること' do
          @agent.mail_address = "m" * 257
          @agent.save.should be_false
        end
      end
    end

  end

end

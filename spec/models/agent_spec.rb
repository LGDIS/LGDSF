# -*- coding:utf-8 -*-
require 'spec_helper'

describe Agent do

  before do
    @agent = FactoryGirl.build(:agent)
  end

  context '正常の場合' do

    describe '@agent' do
      it 'DB登録が成功すること' do
        @agent.save.should be_true
      end
    end

    describe '@agent.name' do
      context 'nameが64文字以内の場合' do
        it 'DB登録が成功すること' do
          @agent.name = 'a' * 64
          @agent.save.should be_true
        end
        it 'Stringクラスであること' do
          @agent.name.should be_instance_of(String)
        end
      end
    end

    describe '@agent.mail_address' do
      context 'mail_addressが256文字以内の場合' do
        it 'DB登録が成功すること' do
          @agent.mail_address = 'a' * 256
          @agent.save.should be_true
        end
        it 'Stringクラスであること' do
          @agent.mail_address.should be_instance_of(String)
        end
      end
    end

  end

  context '異常の場合' do

    describe '@agent.name' do
      context 'nameが65文字以上の場合' do
        it 'DB登録が失敗すること' do
          @agent.name = "a" * 65
          @agent.save.should be_false
        end
      end
    end

    describe '@agent.mail_address' do
      context 'mail_addressが257文字以上の場合' do
        it 'DB登録が失敗すること' do
          @agent.mail_address = 'a' * 257
          @agent.save.should be_false
        end
      end
    end

  end
end

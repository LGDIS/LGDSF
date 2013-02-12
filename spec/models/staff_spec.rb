# -*- coding:utf-8 -*-
require 'spec_helper'

describe Staff do

  before do
    @staff = FactoryGirl.build(:staff)
  end

  context '正常の場合' do

    describe '@staff' do
      it 'DB登録が成功すること' do
        @staff.save.should be_true
      end
    end

    describe '@staff.name' do
      context 'nameが64文字以内の場合' do
        it 'DB登録が成功すること' do
          @staff.name = 'a' * 64
          @staff.save.should be_true
        end
      end
    end

    describe '@staff.destination_code' do
      context 'destination_codeが20文字以内の場合' do
        it 'DB登録が成功すること' do
          @staff.destination_code = 'a' * 20
          @staff.save.should be_true
        end
      end
    end

    describe '@staff.disaster_code' do
      context 'disaster_codeが20文字以内の場合' do
        it 'DB登録が成功すること' do
          @staff.disaster_code = 'a' * 20
          @staff.save.should be_true
        end
      end
    end

  end

  context '異常の場合' do

    describe '@staff.name' do
      context 'nameが65文字以上の場合' do
        it 'DB登録が失敗すること' do
          @staff.name = 'a' * 65
          @staff.save.should be_false
        end
      end
    end

    describe '@staff.destination_code' do
      context 'destination_codeが21文字以上の場合' do
        it 'DB登録が失敗すること' do
          @staff.destination_code = 'a' * 21
          @staff.save.should be_false
        end
      end
    end

    describe '@staff.disaster_code' do
      context 'disaster_codeが21文字以上の場合' do
        it 'DB登録が失敗すること' do
          @staff.disaster_code = 'a' * 21
          @staff.save.should be_false
        end
      end
    end

  end

end

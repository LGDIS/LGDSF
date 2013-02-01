# -*- coding:utf-8 -*-
require 'spec_helper'

describe ApplicationController do
  describe 'init' do
    before do
      @gathering_positions  = Rails.cache.read("gathering_position")
      @predefined_positions = Rails.cache.read("predefined_position")
    end
    context '正常の場合' do
      describe '@gathering_positions' do
        it '1番目のデータが取得できること' do
          @gathering_positions['1'].should be_true
        end
        it 'position_codeが取得できること' do
          @gathering_positions['1']['position_code'].should be_true
        end
        it 'nameが取得できること' do
          @gathering_positions['1']['name'].should be_true
        end
        it 'address_codeが取得できること' do
          @gathering_positions['1']['address_code'].should be_true
        end 
        it 'addressが取得できること' do
          @gathering_positions['1']['address'].should be_true
        end
        it 'latitudeが取得できること' do
          @gathering_positions['1']['latitude'].should be_true
        end
        it 'longitudeが取得できること' do
          @gathering_positions['1']['longitude'].should be_true
        end
        it 'remarksが取得できること' do
          @gathering_positions['1']['remarks'].should be_true
        end
      end
      describe '@predefined_positions' do
        it '1番目のデータが取得できること' do
          @predefined_positions['1'].should be_true
        end
        it 'agent_idが取得できること' do
          @predefined_positions['1']['agent_id'].should be_true
        end
        it 'position_codeが取得できること' do
          @predefined_positions['1']['position_code'].should be_true
        end
      end
    end
    context '異常の場合' do
      describe '@gathering_positions' do
        it '1番目のデータのidが取得できないこと' do
          @gathering_positions['1']['id'].should be_nil
        end
      end
      describe '@predefined_positions' do
        it '1番目のデータのidが取得できないこと' do
          @predefined_positions['1']['id'].should be_nil
        end
      end
    end
  end
end

# -*- coding:utf-8 -*-
require 'spec_helper'

describe Note do

  before do
    @agent = FactoryGirl.build(:agent)
    @staff = FactoryGirl.build(:staff, :agent => @agent)
    @note  = FactoryGirl.build(:note, :staff => @staff)
  end

  describe "#disaster_code" do
    describe "@note" do
      subject { @note }
      its(:disaster_code) { should be_true }
    end
  end

  describe "#name" do
    describe "@note" do
      subject { @note }
      its(:name) { should be_true }
    end
  end

  describe "validates" do

    context "正常の場合" do
      describe "@note" do
        it "DB登録が成功すること" do
          @note.save.should be_true
        end
      end

      describe "@note.note" do
        context "noteが40文字以内の場合" do
          it "DB登録が成功すること" do
            @note.note = 'a' * 40
            @note.save.should be_true
          end
        end
      end
    end

    context "異常の場合" do
      describe "@note.note" do
        context "noteが41文字以上の場合" do
          it "DB登録が失敗すること" do
            @note.note = 'a' * 41
            @note.save.should be_false
          end
        end
      end
    end

  end

end

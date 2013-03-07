# -*- coding:utf-8 -*-
class Department < ActiveRecord::Base
  attr_accessible :department_code, :name, :remarks
end

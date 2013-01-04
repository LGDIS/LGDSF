# encoding: utf-8
class StaffsController < ApplicationController
  before_filter :authenticate_user!, :only => 'index'

  skip_before_filter :check_if_login_required, :except => :index

  layout :layout_selector

  trans_sid

  def layout_selector
    case params[:action]
    when 'mail'
      'lgdsf'
    when 'index'
      'lgdsf_redmine'
    else
      if request.mobile?
        'lgdsf_mobile'
      else
        'lgdsf_smartphone'
      end
    end
  end

  def mail
  end

  def send_form
    if request.mobile?
      render "send_form_mobile"
    else
      render
    end
  end

  def save_send
    #@mail = params[:mail]
    redirect_to :action => "position_form"
  end

  def position_form
    @shelters = Shelter.find(:all)
    if request.mobile?
      render "position_form_mobile"
    else
      render
    end
  end

  def save_position
    @latitude = params[:latitude]
    @longitude = params[:longitude]

    # if request.mobile? and request.mobile.position
      # @latitude = request.mobile.position.lat
      # @longitude = request.mobile.position.lon
    # end

    redirect_to :action => "destination_form"
  end

  def destination_form
    @shelters = Shelter.find(:all)
    if request.mobile?
      render "destination_form_mobile"
    else
      render
    end
  end

  def save_destination
    redirect_to :action => "mail"
  end

  def index
    @shelters = Shelter.find(:all)
    @staffs   = Staff.find(:all)
  end
end

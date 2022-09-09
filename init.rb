# -*- encoding : utf-8 -*-
require 'redmine'
require_relative 'lib/list_user'
require_relative 'lib/dateTools'

Redmine::Plugin.register :redmine_workload do
  name 'Redmine workload plugin'
  author 'Jost Baron'
  description 'This is a plugin for Redmine, originally developed by Rafael Calleja. It ' +
              'displays the estimated number of hours users have to work to finish ' +
              'all their assigned issus on time.'
  version '1.1.1'
  url 'https://github.com/JostBaron/redmine_workload'
  author_url 'http://netzkönig.de/'

  menu :top_menu, :WorkLoad, { :controller => 'work_load', :action => 'show' }, :caption => :workload_title,
    :if =>  Proc.new { User.current.logged? }


  settings :partial => 'settings/workload_settings',
           :default => {
              "general_workday_monday"    => 'checked',
              "general_workday_tuesday"   => 'checked',
              'general_workday_wednesday' => 'checked',
              'general_workday_thursday'  => 'checked',
              'general_workday_friday'    => 'checked',
              'general_workday_saturday'  => '',
              'general_workday_sunday'    => '',
              'threshold_lowload_min'     => 0.1,
              'threshold_normalload_min'  => 7,
              'threshold_highload_min'    => 8.5,
           }

  project_module :Workload do
    permission :view_project_workload, :work_load => :show
    permission :edit_national_holiday, :wl_national_holiday => [:create, :update, :destroy ]
    permission :edit_user_vacations,   :wl_user_vacations   => [:create, :update, :destroy ]
    permission :edit_user_data,        :wl_user_datas       => :create_update
  end
end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
   def view_layouts_base_html_head(context)
		 javascript_include_tag('slides', :plugin => :redmine_workload ) +
     stylesheet_link_tag('style', :plugin => :redmine_workload )
   end
end

#Ignore Files For zeitwerk Autoload
# rails zeitwerk:check Passed!
if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib') }
end
# require File.dirname(__FILE__) + '/lib'

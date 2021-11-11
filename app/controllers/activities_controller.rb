class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[read]

  def read
    activity = current_user.activities.find(params[:id])
    activity.read! if activity.unread?
    binding.pry
    redirect_to activity.redirect_path
  end
end

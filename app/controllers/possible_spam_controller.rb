# Controller that lets users mark models and spam

class PossibleSpamController < ApplicationController

  before_filter :require_login

  def mark_as_spam
    SpamWarning.create(:person_id => @person.id,
                       :node_id => params[:id])
    flash[:notice] = "Thanks for letting us know about this possible spam!"
    redirect_to :back
  end

  def list

  end

end

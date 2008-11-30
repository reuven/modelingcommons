class AccountController < ApplicationController

  before_filter :require_login, :except => [:new, :create, :login, :login_action, :send_password, :send_password_action]

  def new
    @new_person = Person.new
  end

  def create
    @new_person = Person.new(params[:new_person])

    begin
      @new_person.save!
      flash[:notice] = "Congratulations, #{@new_person.first_name}!  You are now registered with the Modeling Commons.  We're delighted that you've joined us."
      Notifications.deliver_signup(@new_person)
      session[:person_id] = @new_person.id
      redirect_to :controller => "browse", :action => "index"
    rescue Exception => e
      flash[:notice] = e.message
      redirect_to :back
    end

  end

  def login
  end

  def login_action
    @person =
      Person.find_by_email_address_and_password(params[:email_address].strip,
                                                params[:password].strip)

    if @person.blank?
      flash[:notice] = "Sorry, but no user exists with that e-mail address and password.  Please try again."
      redirect_to :back
      return
    end

    flash[:notice] = "Welcome back to the commons, #{@person.first_name}!"
    session[:person_id] = @person.id
    redirect_to :controller => "account", :action => "mypage"
  end

  def logout
    @person = nil
    session[:person_id] = nil
    flash[:notice] = "You have been logged out.  Please come back soon!"
    redirect_to :controller => "account", :action => "index"
  end

  def mypage
    if params[:id].blank?
      @the_person = @person
    else
      @the_person = Person.find(params[:id].to_i)
    end

    how_new_is_new = 6.months.ago

    @postings = Posting.find(:all,
                             :conditions => ["is_question = true AND person_id <> ? and created_at >= ?", @the_person.id, how_new_is_new])

    @recent_tags = Tag.find(:all, :order => 'created_at DESC',
                            :conditions => ["created_at >= ?", how_new_is_new ])

    @recent_tagged_models = TaggedNode.find(:all, :order => 'created_at DESC',
                                            :conditions => ["created_at >= ?", how_new_is_new ])
    @tag_events = [@recent_tags, @recent_tagged_models].flatten.sort_by { |t| t.created_at}


    # Model updates
    @recent_models = @the_person.models.select { |m| m.created_at >= how_new_is_new }.sort_by { |m| m.created_at }

    @model_events = @recent_models;

    #     # mode-viewed models
    @most_viewed = LoggedAction.count(:conditions => "url ilike '/browse/one_model%' and node_id IS NOT null",
                                      :group => "node_id",
                                      :order => "count_all DESC")
    @most_viewed = @most_viewed.map { |m| [Node.find(m[0]), m[1]]}

    #     # mode-downloaded models
    @most_downloaded = LoggedAction.count(:conditions => "url ilike '/browse/download_model%' and node_id IS NOT null",
                                      :group => "node_id",
                                      :order => "count_all DESC")
    @most_downloaded = @most_downloaded.map { |m| [Node.find(m[0]), m[1]]}


  end

  def reset_password
    dictionary_file = File.new('/etc/dictionaries-common/words', 'r')
    dictionary_file_contents = dictionary_file.read
    dictionary_words  = dictionary_file_contents.split("\n")
    dictionary_words.delete_if { |word| word.length > 5 }

    # Create our password
    word1 = dictionary_words[rand(dictionary_words.length)].strip.downcase
    number = rand 10000
    word2 = dictionary_words[rand(dictionary_words.length)].strip.downcase

    new_password = word1 + number.to_s + word2

    new_password.gsub!(/[^a-z0-9]/, '')

    @person.password = new_password
    @person.save!

    flash[:notice] = "Your password has been reset.  A new password was sent to you via e-mail."
    Notifications.deliver_reset_password(@person)
    redirect_to :controller => "browse", :action => "index"
  end

  def update_password_action
    new_password = params[:new_password]
    new_password_confirmation = params[:new_password_confirmation]

    if new_password != new_password_confirmation
      flash[:notice] = "You did not enter the same password in both fields.  Please try again."
      redirect_to :back
      return
    else
      @person.password = new_password
      flash[:notice] = "Your new password has been set.  A confirmation notice was sent via e-mail."
      Notifications.deliver_changed_password(@person)
      redirect_to :mypage
      begin
        @person.save!
      rescue Exception => e
        flash[:notice] = e.message
        redirect_to :back
      end
    end
  end

  def send_password_action
    email_address = params[:email_address]

    if email_address.blank?
      flash[:notice] = "You must enter an e-mail address to receive a reminder."
      redirect_to :back
      return
    end

    @person = Person.find_by_email_address(email_address)

    if email_address.index('@').nil?
      flash[:notice] = "Sorry, but '#{email_address}' is not a valid e-mail address.  Please try again."
      redirect_to :back
    elsif @person
      Notifications.deliver_password_reminder(@person)
      flash[:notice] = "A password reminder was sent to your e-mail address."
      redirect_to :controller => :account, :action => :login
    else
      flash[:notice] = "Sorry, but '#{email_address}' is not listed in our system.  Please register."
      redirect_to :back
    end

  end

end

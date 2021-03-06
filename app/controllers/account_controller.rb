# Controller that handles creation and working with user accounts

class AccountController < ApplicationController

  before_filter :require_login, :only => [:edit, :update, :logout, :tags, :mygroups, :groups]
  before_filter :all_news, :only => [:mypage, :login]

  def new_front_page
    render :layout => 'application_nomargin'
  end

  def new
    @new_person = Person.new
    @countries = [
                  "Afghanistan",
                  "Aland Islands",
                  "Albania",
                  "Algeria",
                  "American Samoa",
                  "Andorra",
                  "Angola",
                  "Anguilla",
                  "Antarctica",
                  "Antigua And Barbuda",
                  "Argentina",
                  "Armenia",
                  "Aruba",
                  "Australia",
                  "Austria",
                  "Azerbaijan",
                  "Bahamas",
                  "Bahrain",
                  "Bangladesh",
                  "Barbados",
                  "Belarus",
                  "Belgium",
                  "Belize",
                  "Benin",
                  "Bermuda",
                  "Bhutan",
                  "Bolivia",
                  "Bosnia and Herzegowina",
                  "Botswana",
                  "Bouvet Island",
                  "Brazil",
                  "British Indian Ocean Territory",
                  "Brunei Darussalam",
                  "Bulgaria",
                  "Burkina Faso",
                  "Burundi",
                  "Cambodia",
                  "Cameroon",
                  "Canada",
                  "Cape Verde",
                  "Cayman Islands",
                  "Central African Republic",
                  "Chad",
                  "Chile",
                  "China",
                  "Christmas Island",
                  "Cocos (Keeling) Islands",
                  "Colombia",
                  "Comoros",
                  "Congo",
                  "Congo, the Democratic Republic of the",
                  "Cook Islands",
                  "Costa Rica",
                  "Cote d'Ivoire",
                  "Croatia",
                  "Cuba",
                  "Cyprus",
                  "Czech Republic",
                  "Denmark",
                  "Djibouti",
                  "Dominica",
                  "Dominican Republic",
                  "Ecuador",
                  "Egypt",
                  "El Salvador",
                  "Equatorial Guinea",
                  "Eritrea",
                  "Estonia",
                  "Ethiopia",
                  "Falkland Islands (Malvinas)",
                  "Faroe Islands",
                  "Fiji",
                  "Finland",
                  "France",
                  "French Guiana",
                  "French Polynesia",
                  "French Southern Territories",
                  "Gabon",
                  "Gambia",
                  "Georgia",
                  "Germany",
                  "Ghana",
                  "Gibraltar",
                  "Greece",
                  "Greenland",
                  "Grenada",
                  "Guadeloupe",
                  "Guam",
                  "Guatemala",
                  "Guernsey",
                  "Guinea",
                  "Guinea-Bissau",
                  "Guyana",
                  "Haiti",
                  "Heard and McDonald Islands",
                  "Holy See (Vatican City State)",
                  "Honduras",
                  "Hong Kong",
                  "Hungary",
                  "Iceland",
                  "India",
                  "Indonesia",
                  "Iran, Islamic Republic of",
                  "Iraq",
                  "Ireland",
                  "Isle of Man",
                  "Israel",
                  "Italy",
                  "Jamaica",
                  "Japan",
                  "Jersey",
                  "Jordan",
                  "Kazakhstan",
                  "Kenya",
                  "Kiribati",
                  "Korea, Democratic People's Republic of",
                  "Korea, Republic of",
                  "Kuwait",
                  "Kyrgyzstan",
                  "Lao People's Democratic Republic",
                  "Latvia",
                  "Lebanon",
                  "Lesotho",
                  "Liberia",
                  "Libyan Arab Jamahiriya",
                  "Liechtenstein",
                  "Lithuania",
                  "Luxembourg",
                  "Macao",
                  "Macedonia, The Former Yugoslav Republic Of",
                  "Madagascar",
                  "Malawi",
                  "Malaysia",
                  "Maldives",
                  "Mali",
                  "Malta",
                  "Marshall Islands",
                  "Martinique",
                  "Mauritania",
                  "Mauritius",
                  "Mayotte",
                  "Mexico",
                  "Micronesia, Federated States of",
                  "Moldova, Republic of",
                  "Monaco",
                  "Mongolia",
                  "Montenegro",
                  "Montserrat",
                  "Morocco",
                  "Mozambique",
                  "Myanmar",
                  "Namibia",
                  "Nauru",
                  "Nepal",
                  "Netherlands",
                  "Netherlands Antilles",
                  "New Caledonia",
                  "New Zealand",
                  "Nicaragua",
                  "Niger",
                  "Nigeria",
                  "Niue",
                  "Norfolk Island",
                  "Northern Mariana Islands",
                  "Norway",
                  "Oman",
                  "Pakistan",
                  "Palau",
                  "Palestinian Territory, Occupied",
                  "Panama",
                  "Papua New Guinea",
                  "Paraguay",
                  "Peru",
                  "Philippines",
                  "Pitcairn",
                  "Poland",
                  "Portugal",
                  "Puerto Rico",
                  "Qatar",
                  "Reunion",
                  "Romania",
                  "Russian Federation",
                  "Rwanda",
                  "Saint Barthelemy",
                  "Saint Helena",
                  "Saint Kitts and Nevis",
                  "Saint Lucia",
                  "Saint Pierre and Miquelon",
                  "Saint Vincent and the Grenadines",
                  "Samoa",
                  "San Marino",
                  "Sao Tome and Principe",
                  "Saudi Arabia",
                  "Senegal",
                  "Serbia",
                  "Seychelles",
                  "Sierra Leone",
                  "Singapore",
                  "Slovakia",
                  "Slovenia",
                  "Solomon Islands",
                  "Somalia",
                  "South Africa",
                  "South Georgia and the South Sandwich Islands",
                  "Spain",
                  "Sri Lanka",
                  "Sudan",
                  "Suriname",
                  "Svalbard and Jan Mayen",
                  "Swaziland",
                  "Sweden",
                  "Switzerland",
                  "Syrian Arab Republic",
                  "Taiwan, Province of China",
                  "Tajikistan",
                  "Tanzania, United Republic of",
                  "Thailand",
                  "Timor-Leste",
                  "Togo",
                  "Tokelau",
                  "Tonga",
                  "Trinidad and Tobago",
                  "Tunisia",
                  "Turkey",
                  "Turkmenistan",
                  "Turks and Caicos Islands",
                  "Tuvalu",
                  "Uganda",
                  "Ukraine",
                  "United Arab Emirates",
                  "United Kingdom",
                  "United States",
                  "United States Minor Outlying Islands",
                  "Uruguay",
                  "Uzbekistan",
                  "Vanuatu",
                  "Venezuela",
                  "Viet Nam",
                  "Virgin Islands, British",
                  "Virgin Islands, U.S.",
                  "Wallis and Futuna",
                  "Western Sahara",
                  "Yemen",
                  "Zambia",
                  "Zimbabwe"
                 ]
    respond_to do |format| 
      format.json do 
        render :json => {:user_agreement => render_to_string(:partial => 'user_agreement', :layout => false, :formats => 'html'), :countries => @countries.map{|e| {:name => e, :priority => ['United States'].include?(e) }} }
      end
      format.html do
        render 
      end
    end
  end

  def create
    @new_person = Person.new(params[:new_person])
    if @new_person.save
      flash[:notice] = "Congratulations, #{@new_person.first_name}!  You are now registered with the Modeling Commons.  We're delighted that you've joined us."

      Notifications.signup(@new_person, params[:new_person][:password]).deliver
      session[:person_id] = @new_person.id
      respond_to do |format| 
        format.json do 
          person_response = {:email_address => @new_person.email_address, :first_name => @new_person.first_name, :last_name => @new_person.last_name, :id => @new_person.id, :avatar => @new_person.avatar.url}
          response = {:status => 'SUCCESS', :person => person_response}
          render :json => response
        end
        format.html do
          redirect_to :controller => :account, :action => :mypage
        end
      end
    else
      respond_to do |format| 
        format.json do 
          render :json => {:status => 'ERROR_CREATING_USER'}
        end
        format.html do
          #render :action => :new
          flash[:notice] = "Error creating new user!  You shouldn't see this message, so please contact us at modelingcommons@ccl.northwestern.edu to figure out what went wrong!"
          redirect_to :action => :new
        end
      end
      
    end
  end

  def edit
  end

  def tags
  end

  def update
    if params[:person][:password].blank?
      params[:person].delete(:password)
      params[:person].delete(:password_confirmation)
    end

    params[:person][:password] = Person.encrypted_password(@person.salt, params[:person][:password])    
    params[:person][:password_confirmation] = Person.encrypted_password(@person.salt, params[:person][:password_confirmation])    

    begin
      @person.update_attributes!(params[:person])
      flash[:notice] = "Successfully updated your account."
      redirect_to :back
    rescue Exception => exception
      flash[:notice] = "Error updating your account: '#{exception.message}'"
      redirect_to :back
    end

  end

  def login
    render :layout => 'application_nomargin'
  end

  def login_action
    if params[:email_address].blank? or params[:password].blank?
      respond_to do |format|
        format.html do
          flash[:notice] = "You must provide an e-mail address and password in order to log in."
          redirect_to :controller => :account, :action => :login
          
        end
        format.json do 
          response = {:status => 'MISSING_PARAMETERS'}
          render :json => response
        end
      end
      return
    end

    @person = Person.where("lower(email_address) = lower(?)", params[:email_address].strip).first
    if @person.nil?
      logger.warn "Attempted login with non-existent email_address '#{params[:email_address]}'"
      respond_to do |format| 
        format.html do 
          flash[:notice] = "Sorry, but no user has that e-mail and password. We can send you a password reminder, if you need."
          redirect_to :back
          
        end
        format.json do 
          response = {:status => 'INVALID_CREDENTIALS'}
          render :json => response
        end
        
      end
      return
    end

    encrypted_user_input = Person.encrypted_password(@person.salt, params[:password])
    if encrypted_user_input != @person.password
      logger.warn "Attempted login for email_address '#{params[:email_address]}' with incorrect password '#{params[:password]}'"
      respond_to do |format|
        format.html do 
          flash[:notice] = "Sorry, but no user exists with that e-mail address and password.  Please try again."
          redirect_to :back
        end
        format.json do
          response = {:status => 'INVALID_CREDENTIALS'}
          render :json => response
        end
      end
      return
    end


    session[:person_id] = @person.id
    
    
    respond_to do |format| 
      format.html do 
        flash[:notice] = "Welcome back to the Commons, #{@person.first_name}!"
        redirect_to :controller => :account, :action => :mypage
      end
      format.json do 
        person_response = {:email_address => @person.email_address, :first_name => @person.first_name, :last_name => @person.last_name, :id => @person.id, :avatar => @person.avatar.url}
        response = {:status => 'SUCCESS', :person => person_response}
        render :json => response
      end
    end
    
  end

  def logout
    @person = nil
    session[:person_id] = nil
    respond_to do |format|
      format.html do 
        flash[:notice] = "You have been logged out.  Please come back soon!"
        redirect_to :controller => :account, :action => :login
      end
      format.json do 
        response = {:status => 'SUCCESS'}
        render :json => response
      end
    end
    
  end

  def mypage
    return redirect_to :controller => :account, :action => :login if (@person.nil? and params[:id].blank?)

    if params[:id].blank?
      @the_person = @person
    else
      @the_person = Person.find(params[:id].to_i, :include => [:postings, :tags, :tagged_nodes])
    end

    limit = 10
    db_search_factor = 2 # fetch search_factor * limit records from db before filtering to see if user has read permission
    how_new_is_new = 2.weeks.ago

    #New tags (type Tag)
    @recent_tags = @the_person.tags.select { |tag| tag.created_at >= how_new_is_new}

    #Models that have recently had a tag attached (type TaggedNode)
    @recent_tagged_models = @the_person.tagged_nodes.select { |tagged_node| tagged_node.node.visible_to_user?(@person) and tagged_node.created_at >= how_new_is_new}

    @recent_tag_events = [@recent_tags, @recent_tagged_models].flatten.sort_by { |tag| tag.created_at}.reverse[0..limit - 1]

    @models_wanting_help = Node.where(:wants_help => true).all.select { |n| n.visible_to_user?(@person) }[0..limit - 1]
    
    # Model updates
    @model_events = @the_person.models.select {|model| model.updated_at >= how_new_is_new && model.visible_to_user?(@person)}.sort{|a, b| b.updated_at <=> a.updated_at}[0..limit - 1]
    @group_model_events = @the_person.models.select {|model| model.updated_at >= how_new_is_new && model.visible_to_user?(@person) && model.group && model.group.members.include?(@person)}.sort{|a, b| b.updated_at <=> a.updated_at}[0..limit - 1]
    
    render :layout => 'application_nomargin'
  end

  def reset_password_action
    email_address = params[:email_address].to_s

    if email_address.index('@').nil?
      flash[:notice] = "Sorry, but '#{email_address}' is not a valid e-mail address.  Please try again."
      redirect_to :controller => :account, :action => :reset_password
      return
    end

    @person = Person.find_by_email_address(email_address)

    if @person
      new_password = ''
      8.times { new_password << ('a'..'z').to_a.shuffle.first }

      # Do this to deal with people who haven't signed the consent form,
      # so their model won't pass validation
      encrypted_password = Person.encrypted_password(@person.salt, new_password)
      @person.update_attribute(:password, encrypted_password)

      Notifications.password_reminder(@person, new_password).deliver
      flash[:notice] = "Your password has been reset.  The new password was sent to your e-mail address."
      redirect_to :controller => :account, :action => :login
    else
      flash[:notice] = "Sorry, but '#{email_address}' is not listed in our system.  Please register."
      redirect_to :back
    end

  end

  def follow
    if params[:id].blank?
      flash[:notice] = "You must indicate the person whose actions you wish to follow."
      redirect_to :back
      return
    end

    @new_things = [ ]
    how_recent = 6.months.ago

    @the_person = Person.find(params[:id])

    if @person
      @new_things +=
        @person.versions.select { |node_version| node_version.created_at >= how_recent }.map{ |node_version| node_version.new_thing } 
      @new_things +=
        @person.postings.select { |person| person.created_at >= how_recent }.map{ |person| person.new_thing } 
      @new_things +=
        @person.tagged_nodes.select { |tagged_node| tagged_node.created_at >= how_recent }.map{ |tagged_node| tagged_node.new_thing } 
    end

    respond_to do |format|
      format.html { @new_things }
      format.atom { @new_things }
    end
  end

  def models
    respond_to do |format|
      #standard html request for web app
      format.html do
        if params[:id].blank?
          @the_person = @person
        else
          @the_person = @the_person = Person.find(params[:id])
        end
        render :layout => 'application_nomargin'
      end
      format.json do
        #json request from Netlogo existing model search
        query = params[:query].blank? ? "" : params[:query].downcase
        count = params[:count].blank? ? 10 : params[:count].to_i
        results = Node.all(:conditions => ["name ILIKE ?", '%' + query + '%'], :limit => count)
        results = results.select {|n| 
          n.visible_to_user?(@person)
        }
        results = results.sort {|a, b| a.name.downcase <=> b.name.downcase}
        
        if !params[:changeability].blank?
          results = results.select {|model|
            model.changeable_by_user?(@person)
          }
        end
        
        results = results[0..count-1]
        results = results.collect {|model| 
          {
            :name => model.name,
            :id => model.id
          }
        }
        render :json => {:models => results}
      end
    end
    
  end
  
  def groups
    render :layout => 'application_nomargin'
  end
  
  def find_people
    query = params[:query].blank? ? "" : params[:query].downcase
    count = params[:count].blank? ? 20 : params[:count].to_i
    render :json => Person.search(query).sort {|a, b| a.fullname.downcase <=> b.fullname.downcase}[0..count-1].map {|person| {:id => person.id, :html => render_to_string(:partial => 'selectable_person', :layout => false, :formats => 'html', :locals => { :person => person})}}
  end
  
  def get_feed
    @all_model_events = Node.unscoped.order("updated_at DESC").limit(30).all.select { |node| node.visible_to_user?(@person)}
    @tag_events = TaggedNode.all(:order => 'updated_at DESC', :limit => 30)
    #render :json => @all_model_events.map {|model| {:created_at => model.created_at, :author => {:name => model.person.fullname, :id => model.person.id, :url => url_for(:controller => :account, :action => :mypage, :id => model.person.id, :image => model.person.avatar.url(:thumb))}, :name => model.name, :id => model.id}}
    render :json => @tag_events.map {|tagged| {:nodename => tagged.node.name, :tag_node_id => tagged.id, :node_id => tagged.node.id, :date_tagged => tagged.created_at, :tag_id => tagged.tag.id, :comment => tagged.comment}}
  end
  
  def list_groups
    render :json => {:groups => @person.memberships.sort_by {|m| m.group_name.downcase}.map do |e| 
        {:id => e.group_id, :name => e.group_name}
      end
    }
  end


  def download
    if params[:id].blank?
      @the_person = @person
    else
      @the_person = Person.find(params[:id].to_i)
    end

    send_file(@the_person.create_zipfile(@person), :filename => @the_person.zipfile_name, :type => 'application/zip', :disposition => "inline")
  end

end

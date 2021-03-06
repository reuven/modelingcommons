# Model for sending e-mail notifications

class Notifications < ActionMailer::Base

  default :from => 'nlcommons@modelingcommons.org'
  
  NLCOMMONS_LIST = 'modelingcommons@ccl.northwestern.edu'

  ActionMailer::Base.smtp_settings = {
    :address => "mail.modelingcommons.org",
    :port => 25,
    :domain => "modelingcommons.org",
    :authentication => :plain,
    :enable_starttls_auto => false
  }

  def wrap_subject(text)
    text = "Modeling Commons: #{text}"

    if Rails.env.production?
      text
    else
      "[#{Rails.env}] #{text}"
    end
  end

  def signup(person, cleartext_password)
    @recipients = person.email_address
    @person = person
    logger.warn "Cleartext password = '#{cleartext_password}'"
    @cleartext_password = cleartext_password

    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("Welcome to the NetLogo Modeling Commons!"))
  end

  def reset_password(person)
    @recipients = person.email_address
    @person = person
    mail(:to => @recipients,
         :subject => wrap_subject('Your new password'))
  end

  def password_reminder(person, new_password)
    @recipients = person.email_address
    @person = person
    @new_password = new_password
    mail(:to => @recipients,
         :subject => wrap_subject('Your password'))
  end

  def changed_password(person)
    @recipients = person.email_address
    @person = person
    mail(:to => @recipients,
         :subject => wrap_subject('Your new password'))
  end

  def modified_model(nlmodel, current_author)
    @recipients = nlmodel.people.select {|p| p.send_model_updates?}.map {|person| person.email_address}
    @recipients.delete(current_author.email_address)

    @nlmodel = nlmodel
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("Update to the '#{nlmodel.name}' model"))
  end

  def applied_tag(people, tag, node)
    @recipients = people.select {|p| p.send_tag_updates?}.map {|person| person.email_address}
    @tag = tag
    @node = node
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("'#{tag.name}' tag was applied to '#{node.name}' model"))
  end

  def updated_discussion(nlmodel, current_author)
    author_addresses = nlmodel.people.map{|person| person.email_address}
    #posting_addresses = nlmodel.active_postings.map {|ap| ap.person}.select {|p| p.send_model_updates?}.map { |p| p.email_address}
    posting_addresses = nlmodel.active_postings.map {|ap| ap.person}.map { |p| p.email_address}
    @recipients = (author_addresses + posting_addresses).uniq
    @recipients.delete(current_author.email_address)

    @nlmodel = nlmodel
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("Updated discussion of the #{nlmodel.name} model"))
  end

  def invited_to_group(person, membership)
    @recipients = person.email_address
    @membership = membership
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject('Group invitation from the NetLogo Modeling Commons'))
  end

  def friend_recommendation(sender, friend_email_address, node)
    @recipients = friend_email_address
    @cc = sender.email_address
    @node = node
    @sender = sender
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject('View an interesting NetLogo model'))
  end

  def recommended_message(recommender, people, model)
    @recipients = recommender.email_address
    @nlmodel = model
    @recommender = recommender
    mail(:to => @recipients,
         :bcc => people.map{|person| person.email_address},
         :subject => wrap_subject("Recommendation for the '#{model.name}' model in the NetLogo Modeling Commons"))
  end

  def spam_warning(node, person)
    @recipients = 'modelingcommons@ccl.northwestern.edu'
    @node = node
    @person = person
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("Spam reported for the '#{node.name}' model in the NetLogo Modeling Commons"))
  end

  def upload_acknowledgement(node, person)
    @recipients = person.email_address
    @node = node
    @person = person
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("#{person.first_name}, thanks for uploading the '#{node.name}' model!"))
  end

  def collaboration_notice(node, person)
    @cc = node.people.map { |p| p.email_address }
    @recipients = person.email_address
    @node = node
    @person = person
    mail(:to => @recipients,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("#{person.first_name}, you have been added as a collaborator to the '#{node.name}' model"))
  end

  def nonmember_collaboration_notice(node, nmc, person)
    @node = node
    @nmc = nmc
    @person = person
    mail(:to => @nmc.email_address,
         :cc => @person.email_address,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("You have been added as a collaborator to the '#{node.name}' model"))
  end


  def untagged_models_reminder(person, untagged_models)
    @person = person
    @untagged_models = untagged_models
    @tag_count = Tag.count
    mail(:to => @person.email_address,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("#{person.first_name}, don't forget to tag your models!"))
  end

  def solo_models_reminder(person, solo_models)
    @person = person
    @solo_models = solo_models
    mail(:to => @person.email_address,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("#{person.first_name}, have you credited your collaborators?"))
  end


  def views_downloads_update(person)
    @person = person
    @number_of_people = Person.count
    @number_of_models = Node.count
    @new_people_last_week = Person.where("created_at > now() - interval '1 week'").count
    @new_models_last_week = Node.where("created_at > now() - interval '1 week'").count
    @models_looking_for_help = Node.where("wants_help = 't'")

    mail(:to => @person.email_address,
         :bcc => NLCOMMONS_LIST,
         :subject => wrap_subject("#{person.first_name}, how many people have seen your models?"))
  end

end

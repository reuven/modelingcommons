Given /^a comment with with title "([^\"]*)" and body "([^\"]*)" for model "([^\"]*)" by user "([^\"]*)"$/ do |title, body, model_name, person_email|
  @user = Person.find_by_email_address(person_email)
  @node = Node.find_by_name(model_name)
  FactoryGirl.create(:posting, :node => @node, :person => @user)
end

Given /^a question with with title "([^\"]*)" and body "([^\"]*)" for model "([^\"]*)" by user "([^\"]*)"$/ do |title, body, model_name, person_email|
  @user = Person.find_by_email_address(person_email)
  @node = Node.find_by_name(model_name)
  FactoryGirl.create(:posting, :node => @node, :person => @user, :is_question => true)
end

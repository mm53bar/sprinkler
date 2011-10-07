This will set up a new ubuntu image with nginx, postgres and ruby in preparation for your rails app to be served by unicorn.  All made possible by [Sprinkle](https://github.com/crafterm/sprinkle).

##Instructions
    
Copy the example config file to 'config.rb' and update it with your settings.

Then run the following:

    bundle install
    bundle exec sprinkle -v -c -s setup.rb

##Deployment

Assuming you're using capistrano for deployment and doing it [the Github way](https://github.com/blog/470-deployment-script-spring-cleaning), you should be able to cap deploy:setup as soon as this recipe has been run.  Note that you'll need to do an nginx restart for it to pick up your unicorns.  If you need some help with your capistrano config, check out [my capistrano gist](https://gist.github.com/1271350).

Here's an easy way to restart nginx from capistrano:

     namespace :nginx do
       desc "Restart nginx"
       task :restart, :roles => :app , :except => { :no_release => true } do
         sudo "/etc/init.d/nginx restart"
       end
     end

Here's an snippet for your database.yml that will configure postgres:

     production:
       adapter: postgresql
       encoding: unicode
       database: filter_production
       username: deploy
       pool: 5

That should be it!  Contact me [@mm53bar](http://twitter.com/mm53bar) if you run into issues.

##What you get

* nginx
* postgresql
* 'deploy' user for use with capistrano
  * your public keys added for easy and secure ssh
* app environment set up at /var/applications/app_name/current
* git
* unicorn-focussed vhost file for nginx
* redis
* ruby-build
* ruby installed from source and symlinked 'cause rvm/rbenv is painful with capistrano

##Contributing

I'm by no means a sysadmin expert.  I've pieced this together over the past few months.  If you have some better ideas, submit a pull request!  Just be sure to figure out how to verify your steps using Sprinkle's verify method.


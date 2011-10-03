This will set up a new ubuntu image with nginx, postgres and ruby in preparation for your rails app to be served by unicorn.

##Instructions
    
Copy the example config file to 'config.rb' and update it with your settings.

Then run the following:

    bundle install
    bundle exec sprinkle -v -c -s setup.rb

##Deployment

Assuming you're using capistrano for deployment and doing it [the Github way](https://github.com/blog/470-deployment-script-spring-cleaning), you should be able to cap deploy:setup as soon as this recipe has been run.  Note that you'll need to do an nginx restart for it to pick up your unicorns.

Here's an easy way to restart nginx from capistrano:

     namespace :nginx do
       desc "Restart nginx"
       task :restart, :roles => :app , :except => { :no_release => true } do
         sudo "/etc/init.d/nginx restart"
       end
     end

Here's an easy snippet for your database.yml that will configure postgres:

     production:
       adapter: postgresql
       encoding: unicode
       database: filter_production
       username: deploy
       pool: 5

That should be it!  Contact me [@mm53bar](http://twitter.com/mm53bar) if you run into issues.


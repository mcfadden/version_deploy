VersionDeploy
=============

Version Deploy is simply a convenient set of rake tasks designed to simplify the deployment process of a rails app.

This gem currently depends on the user having [git-flow](https://github.com/nvie/gitflow/) and a git-flow enabled repository, as well as [heroku](https://github.com/heroku/heroku/) -- `gem install heroku` with two remotes set up called "staging" and "production"



Usage
-----

    rake deploy                      # Deploy your local devlop branch to staging
    rake deploy:production           # Bump the version by one revision and then deploy your local master branch to production
    rake deploy:production:major     # Bump the version by one major version and then deploy your local master branch to production
    rake deploy:production:minor     # Bump the version by one minor version and then deploy your local master branch to production
    rake deploy:production:push      # Deploy your local master branch to production
    rake deploy:production:revision  # Bump the version by one revision and then deploy your local master branch to production
    rake deploy:staging              # Deploy your local devlop branch to staging

You shouldn't ever need to directly change the version, but you may do so with these commands:

    rake app_version                 # Return Current Version
    rake app_version:bump            # Bump current version by one revision
    rake app_version:bump:major      # Bump current version by one major version
    rake app_version:bump:minor      # Bump current version by one minor version
    rake app_version:bump:revision   # Bump current version by one revision
    rake app_version:create          # Create Version file at 0.0.0
    rake app_version:current         # Return Current Version


Installation
------------

`gem install version_deploy`

or with bundler

    #In your Gemfile:
    gem 'version_deploy'
    
    $ bundle install

Once the gem is installed and added to your project you will need to create a version.yml file. This can be done automatically by running
    rake app_version:create

### Contributing to version_deploy
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2012 Ben McFadden. See LICENSE.txt for
further details.


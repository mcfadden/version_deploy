require 'version_deploy'
require 'rake/tasklib'

class Rake::VersionDeployTask < Rake::TaskLib
  
  # Version Management. Requires git flow.
  namespace :g_app_version do
    desc "Create Version file at 0.0.0"
    task :create do
      new_version = Hash.new
      new_version[:major] = 0
      new_version[:minor] = 0
      new_version[:revision] = 0
      update_version(new_version)
    end
  
    desc "Return Current Version"
    task :current do
      current_version
      puts "#{current_version[:major]}.#{current_version[:minor]}.#{current_version[:revision]}"
    end
  
    desc "Bump current version by one revision"
    task :bump do
      Rake::Task['app_version:bump:revision'].invoke
    end
  
    namespace :bump do
      desc "Bump current version by one revision"
      task :revision do
        new_version = current_version
        new_version[:revision] = new_version[:revision] + 1
        update_version(new_version)
      end
    
      desc "Bump current version by one minor version"
      task :minor do
        new_version = current_version
        new_version[:minor] = new_version[:minor] + 1
        new_version[:revision] = 0
        update_version(new_version)
      end
    
      desc "Bump current version by one major version"
      task :major do
        new_version = current_version
        new_version[:major] = new_version[:major] + 1
        new_version[:minor] = 0
        new_version[:revision] = 0
        update_version(new_version)
      end
    
    end

    def update_version(new_version)
      puts "Creating git flow release"
      puts `git status`
      puts `git flow release start #{new_version[:major]}.#{new_version[:minor]}.#{new_version[:revision]}`
      puts "Bumping version number"
      File.open("#{Rails.root}/VERSION.yml", 'w') do |file|
        YAML::dump(new_version, file)
      end
      puts "Committing version bump"
      puts `git commit -am 'Bump Version to #{new_version[:major]}.#{new_version[:minor]}.#{new_version[:revision]}'`
      puts "Finishing git flow release"
      puts `git flow release finish -m 'Release:#{new_version[:major]}.#{new_version[:minor]}.#{new_version[:revision]}' #{new_version[:major]}.#{new_version[:minor]}.#{new_version[:revision]}`
      puts "Pushing release to github"
      puts `git push origin master`
      puts `git push --tags`
      puts "Version #{new_version[:major]}.#{new_version[:minor]}.#{new_version[:revision]} complete"
    end
  
    def current_version
      YAML.load_file("#{Rails.root}/VERSION.yml")
    end
  end
  
  # Deployment management. Requires Heroku access
  namespace :g_deploy do
  
    desc "Deploy your local devlop branch to staging"
    task :staging do
      puts 'Deploying to staging...'
      puts `git push staging develop:master`
      puts `heroku run rake db:migrate --remote staging`
      puts `heroku ps:restart --remote staging`
      puts `heroku open --remote staging`
      puts 'Deployed to staging'
    end
  
    desc "Bump the version by one revision and then deploy your local master branch to production"
    task :production do
      Rake::Task['deploy:production:revision'].invoke
    end
  
    namespace :production do
    
      desc "Bump the version by one revision and then deploy your local master branch to production"
      task :revision do
        input = ''
        STDOUT.puts "Deploy to PRODUCTION. Comfirm by typing 'production'"
        input = STDIN.gets.chomp
        raise "Deploy aborted!" unless input == "production"
    
        Rake::Task['app_version:bump:revision'].invoke
        Rake::Task['deploy:production:push'].invoke
      end
    
      desc "Bump the version by one major version and then deploy your local master branch to production"
      task :major do
        input = ''
        STDOUT.puts "Deploy to PRODUCTION. Comfirm by typing 'production'"
        input = STDIN.gets.chomp
        raise "Deploy aborted!" unless input == "production"
    
        Rake::Task['app_version:bump:major'].invoke
        Rake::Task['deploy:production:push'].invoke
      end
    
      desc "Bump the version by one minor version and then deploy your local master branch to production"
      task :minor do
        input = ''
        STDOUT.puts "Deploy to PRODUCTION. Comfirm by typing 'production'"
        input = STDIN.gets.chomp
        raise "Deploy aborted!" unless input == "production"
    
        Rake::Task['app_version:bump:minor'].invoke
        Rake::Task['deploy:production:push'].invoke
      end
    
      desc "Deploy your local master branch to production"
      task :push do
        puts 'Deploying to production...'
        puts `git push production master:master`
        puts `heroku run rake db:migrate --remote production`
        puts `heroku ps:restart --remote production`
        puts `heroku open --remote production`
        puts 'Deployed to production'
      end
    end
  
  end
  
end
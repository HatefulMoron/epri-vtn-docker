source /usr/share/rvm/scripts/rvm 

cd epri

rake db:setup
rake db:seed

/usr/share/rvm/gems/jruby-1.7.10@oadr/gems/torquebox-3.0.2/bin/torquebox deploy
/usr/share/rvm/gems/jruby-1.7.10@oadr/gems/torquebox-3.0.2/bin/torquebox run -b 0.0.0.0

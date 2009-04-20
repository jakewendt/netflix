Netflix
=======

This is a basic plugin to demo usage of the Netflix API.  It includes a controller and views.  This isn't anything to spectacular.

Requirements
============

Usage of this plugin will require the acquisition of a Netflix API key.

These credentials need to be placed in a netflix.yml file in either RAILS_ROOT/config/ or this plugin's root dir in the format ...

    :application_name: my_app_name
    :consumer_token:   my_consumer_token
    :consumer_secret:  my_consumer_secret

Example
=======

Once you've acquired your Netflix API key ...

    rails my_test_app
    cd my_test_app
    script/plugin install git://github.com/jakewendt/netflix.git
    # install config/netflix.yml
    script/server

Testing
=======

No deep tests yet, but eventually ...

    rake

Copyright (c) 2009 [Jake Wendt], released under the MIT license

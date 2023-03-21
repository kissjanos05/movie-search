// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"
import "js-routes"

import * as Routes from './routes';
window.Routes = Routes;

import "queries"
